import type { Plugin } from "@opencode-ai/plugin"
import { execFile } from "node:child_process"
import { promisify } from "node:util"
import { readFileSync } from "node:fs"

const execFileAsync = promisify(execFile)

let cachedToken: string | undefined
let cachedExp = 0

function getCredentials() {
    const tenant    = readFileSync("/etc/opencode/tenant", "utf8")
    const client_id = readFileSync("/etc/opencode/client_id", "utf8")
    const scope     = readFileSync("/etc/opencode/scope", "utf8")
    const cache_key = readFileSync("/etc/opencode/cache_key", "utf8")

    return {
        tenant: tenant,
        client_id: client_id,
        scope: scope,
        cache_key: cache_key
    }
}

function jwtExp(token: string): number {
    const [, payload] = token.split(".")
    if (!payload) return 0

    const padded = payload.padEnd(payload.length + ((4 - payload.length % 4) % 4), "=")
    const decoded = JSON.parse(Buffer.from(padded, "base64url").toString("utf8"))
    return typeof decoded.exp === "number" ? decoded.exp : 0
}

async function getAzureToken() {
    const now = Math.floor(Date.now() / 1000)
    const creds = getCredentials()

    // Refresh 5 minutes before expiry.
    if (cachedToken && cachedExp - now > 300) {
        return cachedToken
    }

    const { stdout } = await execFileAsync("codex", [
        "login",
        "azure-access-token",
        "--tenant",
        creds.tenant,
        "--client-id",
        creds.client_id,
        "--scope",
        creds.scope,
        "--cache-key",
        creds.cache_key,
        "--timeout-secs",
        "10",
    ], {
        timeout: 300_000,
        maxBuffer: 32 * 1024,
    })

    const token = stdout.trim()
    if (!token || token.split(".").length !== 3) {
        throw new Error("codex did not return a valid Azure access token")
    }

    cachedToken = token
    cachedExp = jwtExp(token)
    return token
}

export const MoogAzureAuth: Plugin = async (ctx) => {
    return {
        auth: {
            provider: "azure",
            methods: [],
            loader: async (_auth, provider) => {
                const apiVersion =
                        typeof provider.options?.apiVersion === "string"
                                ? provider.options.apiVersion
                                : "2025-03-01-preview"

                return {
                    fetch: async (url: string | URL | Request, init?: RequestInit) => {
                        const token = await getAzureToken()

                        const oldUrl = url instanceof Request ? new URL(url.url) : new URL(String(url))

                        const newUrl = new URL(oldUrl)

                        if (apiVersion && !newUrl.searchParams.has("api-version")) {
                            newUrl.searchParams.set("api-version", apiVersion)
                        }

                        if (url instanceof Request) {
                            const headers = new Headers(url.headers)

                            if (init?.headers) {
                                new Headers(init.headers).forEach((value, key) => {
                                    headers.set(key, value)
                                })
                            }

                            headers.set("Authorization", `Bearer ${token}`)
                            headers.delete("api-key")

                            return fetch(new Request(newUrl, url), {
                                ...init,
                                headers,
                            })
                        }

                        const headers = new Headers(init?.headers)
                        headers.set("Authorization", `Bearer ${token}`)
                        headers.delete("api-key")

                        return fetch(newUrl, {
                            ...init,
                            headers,
                        })
                    },
                }
            },
        },
    }
}

export default MoogAzureAuth
