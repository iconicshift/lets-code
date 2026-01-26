{config, ...}: {
  claude.code = {
    enable = true;

    commands = {
      test = ''
        Run Playwright e2e tests

        ```bash
        just test
        ```
      '';

      check = ''
        Run TypeScript type checking

        ```bash
        just check
        ```
      '';

      migrate = ''
        Generate and run database migrations

        ```bash
        just db-migration
        just db-migrate
        ```
      '';

      review = ''
        Review current changes for security, types, and React patterns
      '';
    };

    agents = {
      schema-reviewer = {
        description = "Reviews Drizzle schema changes for correctness and best practices";
        proactive = true;
        tools = ["Read" "Grep"];
        prompt = ''
          You review Drizzle ORM schema changes. Check for:
          - Proper index definitions for query patterns
          - Foreign key relationships and cascades
          - Appropriate column types (especially for pgvector/PostGIS)
          - Migration safety (avoid data loss)
          - Naming conventions consistency
        '';
      };

      route-tester = {
        description = "Writes Playwright e2e tests for React Router routes";
        proactive = false;
        tools = ["Read" "Write" "Edit" "Grep" "Bash"];
        prompt = ''
          You write Playwright e2e tests for React Router 7 applications.
          Follow existing patterns in e2e/*.spec.ts.
          Use accessible locators like page.getByRole().
        '';
      };

      i18n-updater = {
        description = "Keeps i18n translations in sync with component usage";
        proactive = true;
        tools = ["Read" "Edit" "Grep"];
        prompt = ''
          Maintain i18n translations. Add missing keys to app/i18n/en.ts.
          Flag hardcoded user-facing strings.
        '';
      };
    };

    hooks = {
      format-on-edit = {
        enable = true;
        name = "Format edited files";
        hookType = "PostToolUse";
        matcher = "^(Edit|MultiEdit|Write)$";
        command = ''
          file_path=$(jq -r '.tool_input.file_path // empty')
          if [[ -n "$file_path" && -f "$file_path" ]]; then
            treefmt --no-cache "$file_path" 2>/dev/null || true
          fi
        '';
      };
    };

    mcpServers = {
      devenv = {
        type = "stdio";
        command = "devenv";
        args = ["mcp"];
        env.DEVENV_ROOT = config.devenv.root;
      };
    };
  };
}
