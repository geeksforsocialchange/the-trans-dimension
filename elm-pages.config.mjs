import { defineConfig } from "vite";
import adapter from "elm-pages/adapter/netlify.js";

export default {
  vite: defineConfig({}),
  adapter,
  headTagsTemplate(context) {
    return `
  <link rel="stylesheet" href="/style.css" />
  <meta name="generator" content="elm-pages v${context.cliVersion}" />
  <script defer="defer" data-domain="transdimension.uk" src="https://plausible.io/js/script.outbound-links.js"></script>
  <link rel="preconnect" href="https://use.typekit.net" crossorigin />
  <link rel="preconnect" href="https://p.typekit.net" crossorigin />
  <link rel="preload" as="style" href="https://use.typekit.net/qwi3qrw.css" />
  <link rel="stylesheet" href="https://use.typekit.net/qwi3qrw.css" media="print" onload="this.media='all'" />
  <noscript><link rel="stylesheet" href="https://use.typekit.net/qwi3qrw.css" /></noscript>
  `;
  },
  preloadTagForFile(file) {
    // add preload directives for JS assets and font assets, etc., skip for CSS files
    // this function will be called with each file that is procesed by Vite, including any files in your headTagsTemplate in your config
    return !file.endsWith(".css");
  },
};
