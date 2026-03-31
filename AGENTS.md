# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Tasks

```sh
just dev               # Start Docker Compose (PostgreSQL, dev server, Storybook)
just                   # Run check and test in a container (default)
just check             # TypeScript type checking in a container
just test              # Run vitest + Playwright e2e tests in a container
just fmt               # Format code with treefmt
just psql              # Connect to development database
just db-generate       # Generate Drizzle migrations
just db-migrate        # Run Drizzle migrations
```

`just` uses Docker Compose for everything. devenv is optional — it provides
packages and env vars only (no processes).

Host-native users can skip Just and Docker and use pnpm directly:

```sh
pnpm run check         # TypeScript type checking
pnpm test              # Run vitest + Playwright
pnpm run test:unit     # Run vitest only
pnpm run test:e2e      # Run Playwright only
```

## Architecture

React Router 7 full-stack application with Express.js backend and PostgreSQL database.

**Request flow:**

1. `server.js` creates Express app with Vite middleware (dev) or static assets (prod)
2. `server/app.ts` applies security middleware and wraps requests in `DatabaseContext`
3. Route loaders/actions call `database()` from `~/database/context` to access Drizzle ORM
4. `app/root.tsx` provides the root layout with i18n provider and error boundary

**Key patterns:**

- **Database context**: `AsyncLocalStorage` provides thread-safe database access in SSR. Always use `database()` from `~/database/context` in loaders/actions.
- **Route typing**: React Router generates types in `+types/` directories. Import `Route` types for loader/action/component props.
- **i18n**: Translations in `app/i18n/en.ts`. Never hardcode user-facing strings. Use `useTranslation()` hook in components; use `const t = i18n.t.bind(i18n)` in meta functions and error boundaries.

**Directory structure:**

- `app/routes/` - React Router routes with loaders/actions
- `server/middleware/` - Express middleware (CSRF, security headers)
- `database/` - Drizzle schema and context

## Stack

- React 19, React Router 7, TypeScript, Tailwind CSS 4
- Express 5, Drizzle ORM, PostgreSQL 17 (with pgvector, PostGIS)
- Playwright for e2e tests, Storybook for component development
- Docker Compose for development, pnpm for packages, devenv/Nix optional

## Testing

- Small, focused tests that verify one behavior each
- Clear separation between setup and expectations (Given/When/Then)
- Referential transparency: tests must not depend on environment, timezone, or implicit defaults
- Lightweight dependency injection over DI frameworks; pass dependencies as parameters
- Assert on behavior and outcomes, not implementation details
- Only test implementation when critically important (security, privacy)
- Never write tests that compare two unknowns (e.g., "locale A != locale B" proves nothing)

## Git Commits

- Atomic commits: one logical change per commit
- Short imperative summary (e.g., "Add date formatter", not "Added date formatting utility using Intl.DateTimeFormat")
- Longer explanation in the body if needed
- No "Generated with Claude Code" or "Co-Authored-By" lines
