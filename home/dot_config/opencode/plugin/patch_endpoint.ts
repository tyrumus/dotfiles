import type { Plugin } from "@opencode-ai/plugin"

export const PatchApiEndpoint: Plugin = async (ctx) => {
  return {
    auth: {
      provider: "azure",
      methods: [],
      loader: async (_auth, _provider) => {
        await ctx.client.app.log({
          body: { service: "patch-api-endpoint", level: "info", message: "Loader initialized..." }
        })

        return {
          fetch: async (url: string | URL | Request, init?: RequestInit) => {
            const oldUrl = url instanceof Request ? url.url : String(url)
            const newUrl = new URL(oldUrl.replace("/v1/responses","/responses"))

            ctx.client.app.log({
              body: {
                service: "patch-api-endpoint",
                level: "info",
                message: "Patching API Endpoint",
                extra: { oldUrl: oldUrl, newUrl: newUrl.toString()  },
              }
            })

            return fetch(newUrl.toString(), init)
          },
        }
      },
    },
  }
}

export default PatchApiEndpoint
