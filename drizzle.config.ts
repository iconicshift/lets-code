import { defineConfig } from "drizzle-kit";
import { z } from "zod";

const DATABASE_URL = z.string().url().parse(process.env.DATABASE_URL);

// Suppress PostgreSQL NOTICE messages (e.g., "schema already exists, skipping")
const url = new URL(DATABASE_URL);
url.searchParams.set("options", "-c client_min_messages=warning");

export default defineConfig({
  out: "./drizzle",
  schema: "./database/schema.ts",
  dialect: "postgresql",
  dbCredentials: {
    url: url.toString(),
  },
});
