import type { Plugin } from "@opencode-ai/plugin"

export const PatchApiEndpoint: Plugin = async (ctx) => {
  return {
    auth: {
      provider: "azure",
      methods: [],
      loader: async (_auth, provider) => {
        const apiVersion =
          typeof provider.options?.apiVersion === "string" ? provider.options.apiVersion : undefined

        await ctx.client.app.log({
          body: {
            service: "patch-api-endpoint",
            level: "info",
            message: "Loader initialized...",
            extra: { apiVersion },
          },
        })

        return {
          fetch: async (url: string | URL | Request, init?: RequestInit) => {
            const oldUrl = url instanceof Request ? new URL(url.url) : new URL(String(url))
            const newUrl = new URL(oldUrl)

            if (apiVersion && !newUrl.searchParams.has("api-version")) {
              newUrl.searchParams.set("api-version", apiVersion)
            }

            void ctx.client.app.log({
              body: {
                service: "patch-api-endpoint",
                level: "info",
                message: "Patching API Endpoint",
                extra: {
                  oldUrl: oldUrl.toString(),
                  newUrl: newUrl.toString(),
                  method: url instanceof Request ? url.method : init?.method,
                },
              },
            })

            if (url instanceof Request) {
              return fetch(new Request(newUrl, url), init)
            }

            return fetch(newUrl, init)
          },
        }
      },
    },
  }
}

export default PatchApiEndpoint

