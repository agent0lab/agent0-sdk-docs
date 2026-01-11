import { defineCollection } from "astro:content";
import { docsSchema } from "@astrojs/starlight/schema";

// Starlight uses the `docs` content collection by default.
// Use Starlight's schema so required defaults (like `head`) are present.
const docs = defineCollection({
  schema: docsSchema()
});

export const collections = { docs };

