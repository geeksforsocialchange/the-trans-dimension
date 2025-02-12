type ElmPagesInit = {
  load: (elmLoaded: Promise<unknown>) => Promise<void>;
  flags: unknown;
};

interface ElmApp {
  ports: {
    requestUrlChange: {
      subscribe: (callback: (newQuery: string) => void) => void;
    };
    onUrlChange: {
      send: (newUrl: string) => void;
    };
  };
}

const config: ElmPagesInit = {
  load: async function (elmLoaded) {
    const app = await elmLoaded as ElmApp;
    if (app.ports.requestUrlChange) {
      app.ports.requestUrlChange.subscribe((newQuery: string) => {
        // Build the new href with the new query
        const newHref = window.location.pathname + newQuery;

        // Push it into history
        window.history.replaceState({}, "", newHref);

        // Notify Elm of the new URL
        if (app.ports.onUrlChange) {
          app.ports.onUrlChange.send(window.location.href);
        }
      });
    }
  },
  flags: function () {
    return "You can decode this in Shared.elm using Json.Decode.string!";
  },
};

export default config;
