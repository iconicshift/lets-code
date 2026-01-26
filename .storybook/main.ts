import type { StorybookConfig } from "@storybook/react-vite";

const config: StorybookConfig = {
  core: { disableTelemetry: true },
  stories: ["../app/**/*.stories.@(js|jsx|ts|tsx)"],
  framework: {
    name: "@storybook/react-vite",
    options: {
      builder: {
        viteConfigPath: new URL("./vite.config.ts", import.meta.url).pathname,
      },
    },
  },
  // Prevent chokidar from following symlinks into Nix store
  viteFinal: (config) => ({
    ...config,
    server: {
      ...config.server,
      host: process.env.STORYBOOK_HOST || false,
      watch: {
        followSymlinks: false,
        ignored: ["**/.devenv/**", "**/.direnv/**", "**/node_modules/**"],
      },
    },
  }),
};

export default config;
