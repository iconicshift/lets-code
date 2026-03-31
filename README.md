# Let's Code

**Let's Code** is a working React Router application we can hack on for fun.

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/) (or [OrbStack](https://orbstack.dev/))
- [just](https://just.systems/)

## Getting started

Docker Compose runs PostgreSQL, the dev server, and Storybook:

```sh
just dev
```

- **Application:** http://localhost:3000/
- **Storybook:** http://localhost:6006/

Type checking and tests also run in containers:

```sh
just           # check + test (default)
just check     # type checking only
just test      # unit + e2e tests only
```

Environment variables are defined in `.env` at the project root. Docker Compose
overrides `DATABASE_URL` to use the `postgres` service hostname.

### Host-native workflow

If you prefer running Node and pnpm on your host, you'll need to manage
PostgreSQL yourself (e.g. via `just docker up -d postgres`). Then use pnpm
directly:

```sh
pnpm install
pnpm run check         # type checking
pnpm test              # unit + e2e tests
pnpm run test:unit     # vitest only
pnpm run test:e2e      # Playwright only
```

### devenv

[devenv](https://devenv.sh/) is optional. It provides packages (Node, pnpm,
just, formatters) and loads `.env` automatically via direnv. It does not manage
any processes.

## What's in the box?

- [React Router](https://reactrouter.com/home) is a multi-strategy router for
  React bridging the gap from React 18 to React 19.
- [pnpm](https://pnpm.io/) for lightning-fast installation speeds and a smarter,
  safer way to manage dependencies.
- [Storybook](https://storybook.js.org/) is a frontend workshop for building UI
  components and pages in isolation.

### Migrations

Applying migrations is a two step process where one needs to first generate SQL
from TypeScript definitions, and then apply the SQL to a database.

```sh
just db-generate
just db-migrate
```

## Tasks

We have more tasks than time allows. This is intentional. Part of working
together is deciding what to tackle, how deeply to go, and when to move on.

There is no expectation to finish everything. We're interested in how you
approach problems, the trade-offs you consider, and how you communicate your
thinking.

Each task should result in working code integrated with the database and
accessible in the UI.

In each task we're interested in your approach to validation, testing, and
presentation. We're an early stage company so pragmatism and the ability to make
well-informed decisions independently are incredibly important.

### Task 1: Create objectives

Build the foundation for an objective-tracking feature. Users should be able to
create an objective with a title and optional description.

### Task 2: Delete objectives

Add the ability to remove an objective.

### Task 3: Complete objective

Allow marking an objective as completed.
