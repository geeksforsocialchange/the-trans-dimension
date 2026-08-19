import { defineConfig } from "vite";
import adapter from "elm-pages/adapter/netlify.js";

export default {
  vite: defineConfig({}),
  adapter,
  headTagsTemplate(context) {
    return `
  <link rel="stylesheet" href="/style.css" />
  <meta name="generator" content="elm-pages v${context.cliVersion}" />
  <!-- Matomo (stats.gfsc.community, site 2), cookieless.
       enableLinkTracking covers outbound link clicks. -->
  <script>
    var _paq = (window._paq = window._paq || []);
    _paq.push(["disableCookies"]);
    _paq.push(["trackPageView"]);
    _paq.push(["enableLinkTracking"]);
    (function () {
      var u = "https://stats.gfsc.community/";
      _paq.push(["setTrackerUrl", u + "matomo.php"]);
      _paq.push(["setSiteId", "2"]);
      var d = document, g = d.createElement("script"), s = d.getElementsByTagName("script")[0];
      g.async = true; g.src = u + "matomo.js"; s.parentNode.insertBefore(g, s);
    })();
  </script>
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
