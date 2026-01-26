{pkgs, ...}: {
  imports = [
    ./nix/modules/claude-code.nix
  ];

  packages = with pkgs; [
    # Development
    just

    # Formatters
    alejandra
    prettier
    shfmt
    treefmt
  ];

  # Don't forget to keep our Docker Compose environment in sync where
  # appropriate.
  env = {
    DATABASE_URL = "postgres://app:please@127.0.0.1:5432/app_dev";
    DANGEROUSLY_RELAX_CSP = "true";
    E2E_PORT = "3001";
    HSTS_ENABLED = "false";
    NODE_ENV = "development";
    SECURE_COOKIES = "false";
  };

  services.postgres = {
    enable = true;

    extensions = extensions: [
      extensions.pgvector
    ];

    package = pkgs.postgresql_18;

    listen_addresses = "127.0.0.1";
    initialDatabases = [
      {
        name = "app_dev";
        user = "app";
        pass = "please";
      }
      {
        name = "app_test";
        user = "app";
        pass = "please";
      }
    ];

    initialScript = ''
      ALTER USER app CREATEDB;
    '';
  };

  # Pin to Node 22 LTS to avoid React Router typegen CPU bug
  # https://github.com/remix-run/react-router/issues/12721
  languages.javascript.enable = true;
  languages.javascript.package = pkgs.nodejs_22;
  languages.javascript.pnpm.enable = true;

  process.manager.implementation = "process-compose";
  process.managers.process-compose.tui.enable = false;

  processes.setup = {
    exec = "just setup";

    process-compose = {
      depends_on = {
        postgres.condition = "process_healthy";
      };
    };
  };

  processes.remix = {
    exec = "just serve";

    process-compose = {
      availability.restart = "always";

      depends_on = {
        postgres.condition = "process_started";
        setup.condition = "process_completed_successfully";
      };

      is_tty = true;
    };
  };

  processes.storybook = {
    exec = "just storybook";

    process-compose = {
      availability.restart = "always";

      depends_on = {
        setup.condition = "process_completed_successfully";
      };

      is_tty = true;
    };
  };
}
