import { defineConfig } from 'vitest/config';

// Workspace-wide vitest config. Picks up *.test.ts and *.spec.ts in
// apps/ and packages/. Per-package configs (e.g. for path aliases like
// `@/*` → `apps/web/src/*`) can extend or override via their own
// `vitest.config.ts` if needed.
export default defineConfig({
  test: {
    globals: false,
    include: ['{apps,packages}/**/*.{test,spec}.{ts,tsx}'],
    exclude: ['**/node_modules/**', '**/dist/**', '**/.next/**'],
    // Empty-scaffolding hygiene: starter ships with no tests yet, and the
    // README promises `pnpm preflight` exits clean on a fresh clone.
    passWithNoTests: true,
  },
});
