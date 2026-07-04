// @ts-check
import js from '@eslint/js';
import tseslint from 'typescript-eslint';
import prettier from 'eslint-config-prettier';
import globals from 'globals';

export default tseslint.config(
  {
    ignores: [
      '**/node_modules/**',
      '**/.next/**',
      '**/.turbo/**',
      '**/dist/**',
      '**/build/**',
      '**/out/**',
      '**/coverage/**',
      '**/test-results/**',
      '**/playwright-report/**',
      '**/*.tsbuildinfo',
      // Skill packages installed via `npx skills add` — vendored content
      // we don't lint. ESLint doesn't respect .gitignore, hence the
      // duplicate exclusion alongside the .gitignore entry.
      '.agents/**',
      '.claude/skills/**',
    ],
  },
  js.configs.recommended,
  ...tseslint.configs.recommended,
  {
    languageOptions: {
      globals: {
        ...globals.node,
      },
    },
    rules: {
      // AGENTS.md §3 banned patterns, enforced where ESLint can.
      'no-console': 'error',
      eqeqeq: ['error', 'always'],
      'no-var': 'error',
      'no-eval': 'error',
      'no-new-func': 'error',
      'no-empty': ['error', { allowEmptyCatch: false }],
      'prefer-const': 'error',
      '@typescript-eslint/no-explicit-any': 'error',
      '@typescript-eslint/no-unused-vars': [
        'error',
        {
          argsIgnorePattern: '^_',
          varsIgnorePattern: '^_',
          caughtErrorsIgnorePattern: '^_',
        },
      ],
    },
  },
  // Typed lint rules for workspace source. Unawaited promises are one of
  // the most common AI-generated bugs — code that looks right, passes
  // non-typed lint, and silently drops errors. Requires type info, hence
  // projectService — which needs a resolvable tsconfig.json for every
  // matched file. apps/web/tsconfig.json and packages/shared/tsconfig.json
  // ship with the starter for exactly this reason: without them,
  // projectService hard-fails parsing (not a warning) the moment the
  // first real .ts file lands in either package, on a PR unrelated to
  // that failure. Adding a new package under apps/* or packages/*? Give
  // it its own tsconfig.json (extend tsconfig.base.json) before this
  // glob's first matching file, or scope the glob to exclude it.
  {
    files: ['{apps,packages}/**/*.{ts,tsx}'],
    languageOptions: {
      parserOptions: {
        projectService: true,
        tsconfigRootDir: import.meta.dirname,
      },
    },
    rules: {
      '@typescript-eslint/no-floating-promises': 'error',
      '@typescript-eslint/no-misused-promises': 'error',
      '@typescript-eslint/await-thenable': 'error',
    },
  },
  // packages/shared must stay platform-agnostic per AGENTS.md §2.
  // Adjust the file glob if your platform-agnostic package lives elsewhere.
  {
    files: ['packages/shared/**/*.{ts,tsx,js,mjs,cjs}'],
    rules: {
      'no-restricted-globals': [
        'error',
        {
          name: 'document',
          message: 'packages/shared is platform-agnostic per AGENTS.md §2',
        },
        {
          name: 'window',
          message: 'packages/shared is platform-agnostic per AGENTS.md §2',
        },
        {
          name: 'navigator',
          message: 'packages/shared is platform-agnostic per AGENTS.md §2',
        },
      ],
    },
  },
  // Config files and project scripts may use console.
  {
    files: ['**/*.config.{js,mjs,cjs,ts}', 'scripts/**/*.{js,mjs,cjs,ts}'],
    rules: {
      'no-console': 'off',
    },
  },
  prettier,
);
