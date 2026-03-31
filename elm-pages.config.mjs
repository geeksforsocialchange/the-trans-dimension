import { defineConfig } from "vite";
import adapter from "elm-pages/adapter/netlify.js";
import { ManifestOptions, VitePWA } from "vite-plugin-pwa";

export default {
  vite: defineConfig({
    plugins: [
      VitePWA({
        //     manifest: {
        //       name: 'The Trans Dimension',
        //       description: 'An online community hub which will connect trans communities across the UK by collating news, events and services by and for trans people in one easy-to-reach place.',
        //       start_url: '/',
        //       background_color: '#040f39',
        //       theme_color: '#ff7aa7',
        //       display: 'standalone',
        //       icons: [
        //         {
        //           src: '/favicons/android-chrome-192x192.png',
        //           sizes: '192x192',
        //           type: 'image/png'
        //         },
        //         {
        //           src: '/favicons/android-chrome-512x512.png',
        //           sizes: '512x512',
        //           type: 'image/png'
        //         }
        //       ]
        //     },
        //     includeAssets: [
        //       'index.html',
        //       '/favicons/apple-touch-icon.png',
        //       '/favicons/favicon-32x32.png',
        //       '/favicons/favicon-16x16.png'
        //     ],
        //     scope: '/',
        //     skipWaiting: true,
        //     clientsClaim: true,
        registerType: 'autoUpdate',
      })
    ]
  }),
  adapter,
  headTagsTemplate(context) {
    return `
  <link rel="stylesheet" href="/style.css" />
  <meta name="generator" content="elm-pages v${context.cliVersion}" />
  <script defer="defer" data-domain="transdimension.uk" src="https://plausible.io/js/script.outbound-links.js"></script>
  <link rel="stylesheet" preload href="https://use.typekit.net/qwi3qrw.css" />
  `;
  },
  preloadTagForFile(file) {
    // add preload directives for JS assets and font assets, etc., skip for CSS files
    // this function will be called with each file that is procesed by Vite, including any files in your headTagsTemplate in your config
    return !file.endsWith(".css");
  },
};
