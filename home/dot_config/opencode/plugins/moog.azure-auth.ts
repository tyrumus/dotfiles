import { Plugin } from "@opencode/plugin"
import { execFile } from "node:child_process"
import { readFile } from "node:fs/promises"
import { promisify } from "node:util"

const execFileAsync = promisify(execFile)

type AzureConfig = {
  tenant: string
  client_id: string
  scope: string
  cache_key: string
  api_version: string
}

let azureConfig: Promise<AzureConfig> | undefined

let cachedToken: string | undefined
let cachedExp = 0

function jwtExp(token: string): number {
 const [, payload] = token.split(".")
 if (!payload) return 0

 const padded = payload.padEnd(payload.length + ((4 - payload.length % 4) % 4), "=")
 const decoded = JSON.parse(Buffer.from(padded, "base64url").toString("utf8"))
 return typeof decoded.exp === "number" ? decoded.exp : 0
}

async function getAzureToken() {
 const config = await (azureConfig ??= readFile(new URL("/etc/opencode/config.json", import.meta.url), "utf8")
   .then((contents) => JSON.parse(contents) as AzureConfig))

 const now = Math.floor(Date.now() / 1000)

 // Refresh 5 minutes before expiry.
 if (cachedToken && cachedExp - now > 300) {
   return { token: cachedToken, apiVersion: config.api_version }
 }

 const { stdout } = await execFileAsync("codex", [
   "login",
   "azure-access-token",
   "--tenant",
   config.tenant,
   "--client-id",
   config.client_id,
   "--scope",
   config.scope,
   "--cache-key",
   config.cache_key,
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
 return { token, apiVersion: config.api_version }
}

export default Plugin.define({
  id: "moog.azure-auth",

  async setup(ctx) {
    await ctx.session.hook(
      "http.request",
      async (event) => {
        const { token, apiVersion } = await getAzureToken()
        const url = new URL(event.request.url)

        // V1 read this from Azure provider options; MoogAI requires it as a
        // query parameter even though the V2 runtime is OpenAI-compatible.
        if (!url.searchParams.has("api-version")) {
          url.searchParams.set("api-version", apiVersion)
        }

        const request = new Request(url.toString(), event.request)
        request.headers.set("Authorization", `Bearer ${token}`)
        request.headers.delete("api-key")
        event.request = request
      },
      { providerID: "moogai" },
    )
  },
})
