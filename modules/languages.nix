{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Python development
    python311
    python311Packages.pip
    python311Packages.black
    python311Packages.flake8
    python311Packages.isort
    python311Packages.pytest
    poetry

    # Go development
    go
    gopls
    delve
    golangci-lint

    # Zig development
    zig
    zls
  ];

  # Set up Python environment
  home.sessionVariables = {
    PYTHONPATH = "~/.local/lib/python3.11/site-packages:$PYTHONPATH";
  };
}

