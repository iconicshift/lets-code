import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";
import { defineConfig } from "vite";
import { sharedPlugins, watchOptions } from "../vite.shared";

const root = resolve(dirname(fileURLToPath(import.meta.url)), "..");

export default defineConfig({
  root,
  plugins: sharedPlugins(),
  server: {
    watch: watchOptions,
  },
});
