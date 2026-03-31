_default:
    just docker run --rm test

# ------------------------------------------------------------------------------
# Development

# Prepare local development environment
[group('dev')]
setup:
    just docker up -d postgres
    pnpm install
    @just db-migrate
    pnpm exec playwright install chromium
    @echo
    @echo "🚀 Happy hacking!"

# Start development environment using Docker Compose
[group('dev')]
dev:
    just docker up

# Run the node server on the host
[group('dev')]
serve:
    node server.js

# Format project source files
[group('dev')]
fmt:
    treefmt

# Lint project source files
[group('dev')]
lint:
    treefmt --ci --quiet

# ------------------------------------------------------------------------------
# Release

# Type check source files
[group('release')]
check:
    pnpm run check

# Start the app in production mode
[group('release')]
start:
    NODE_ENV=production node server.js

# ------------------------------------------------------------------------------
# Test

# Run project test suite
[group('test')]
test:
    pnpm test

# ------------------------------------------------------------------------------
# Database

# Start an interactive psql session
[group('db')]
psql:
    just docker exec postgres psql -U app app_dev

# Generate migration files from Typescript definitions
[group('db')]
db-generate *args:
    drizzle-kit generate --config drizzle.config.ts {{ args }}

# Apply pending migrations
[group('db')]
db-migrate *args:
    drizzle-kit migrate --config drizzle.config.ts {{ args }}

# Remove project PostgreSQL state
[group('db')]
db-reset:
    #!/usr/bin/env zsh
    echo -n "{{ BOLD }}Delete PostgreSQL data? (y/N): {{ NORMAL }}"
    read response

    if [[ "$response" =~ ^[Yy]$ ]]; then
        just docker rm -sf postgres
        docker volume rm lets-code_postgres-data 2>/dev/null
    fi

# ------------------------------------------------------------------------------
# Build

# Build the app
[group('build')]
build:
    react-router build

# Build a container image via Docker
[group('build')]
docker-build:
    docker build -f docker/Dockerfile.prod -t ai.iconicshift/app:latest .

# Run a container image via Docker
[group('build')]
docker-run *args:
    docker run -p 3000:3000 {{ args }} ai.iconicshift/app:latest

# ------------------------------------------------------------------------------
# Docker

# Run docker compose commands
[group('docker')]
docker *args:
    docker compose -f docker/compose.yml {{ args }}

# ------------------------------------------------------------------------------
# Storybook

# Start Storybook
[group('dev')]
storybook:
    pnpm exec storybook dev -p 6006 --no-open

# Build Storybook
[group('dev')]
storybook-build:
    pnpm exec storybook build
