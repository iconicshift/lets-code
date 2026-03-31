{pkgs, ...}: {
  imports = [
    ./nix/modules/claude-code.nix
  ];

  dotenv.enable = true;

  packages = with pkgs; [
    # Development
    just

    # Formatters
    alejandra
    prettier
    shfmt
    treefmt
  ];

  # Pin to Node 22 LTS to avoid React Router typegen CPU bug
  # https://github.com/remix-run/react-router/issues/12721
  languages.javascript.enable = true;
  languages.javascript.package = pkgs.nodejs_22;
  languages.javascript.pnpm.enable = true;
}
