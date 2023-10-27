{ nix-pre-commit-hooks, ... }:
{
  pre-commit-check = nix-pre-commit-hooks.run {
    # We can use the entire unfiltered source here because pre-commit-hooks automatically
    # uses a .gitignore filter.
    src = ./.;
    hooks = {
      # Nix Hooks
      statix.enable = true; # static analysis
      nixpkgs-fmt.enable = true; # formatting

      # Markdown
      markdownlint = {
        enable = true;
        files = {
          _type = "override";
          content = ''(?<!LICENCE)\.md$'';
          priority = 50;
        };
      };

      # Spell checkers
      typos.enable = true;
    };
    settings = {
      markdownlint.config = {
        # See https://github.com/DavidAnson/markdownlint/blob/main/schema/.markdownlint.jsonc
        line-length = {
          code_blocks = false;
          line_length = 100;
        };
        no-duplicate-heading.siblings_only = true;
        no-inline-html.allowed_elements = [ "span" ];
      };
    };
  };
}
