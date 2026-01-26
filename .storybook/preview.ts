import type { Preview } from "@storybook/react";
import "../app/app.css";

const preview: Preview = {
  parameters: {
    backgrounds: {
      default: "light",
      values: [
        { name: "light", value: "#ffffff" },
        { name: "dark", value: "#030712" },
      ],
    },
  },
};

export default preview;
