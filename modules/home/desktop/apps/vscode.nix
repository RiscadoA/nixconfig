# modules/home/desktop/apps/vscode.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# VS Code home configuration.

{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.desktop.apps.vscode;
  buildExtension = ({ name, publisher, version, sha256, buildInputs ? [ ] }:
    pkgs.unstable.vscode-utils.buildVscodeMarketplaceExtension {
      inherit buildInputs;
      mktplcRef = {
        inherit name publisher version sha256;
      };
    });
in
{
  options.modules.desktop.apps.vscode.enable = mkEnableOption "vscode";

  config = mkIf cfg.enable {
    home.packages = [
      (pkgs.unstable.vscode-with-extensions.override {
        vscodeExtensions = (with pkgs.unstable.vscode-extensions; [
          mkhl.direnv
          github.copilot
          github.copilot-chat
          ms-vscode-remote.remote-ssh
          ms-vsliveshare.vsliveshare
          ms-vscode.hexeditor

          # Theme
          file-icons.file-icons

          # Git
          mhutchie.git-graph
          waderyan.gitblame
          github.vscode-github-actions

          # Spell checker
          streetsidesoftware.code-spell-checker

          # PDF
          tomoki1207.pdf

          # Markdown
          yzhang.markdown-all-in-one
          bierner.markdown-mermaid
          bierner.markdown-emoji

          # Nix
          jnoortheen.nix-ide

          # C/C++
          xaver.clang-format
          ms-vscode.cpptools
          ms-vscode.cmake-tools
          ms-vscode.makefile-tools
          twxs.cmake
          (buildExtension {
            name = "cpptools-themes";
            publisher = "ms-vscode";
            version = "2.0.0";
            sha256 = "sha256-YWA5UsA+cgvI66uB9d9smwghmsqf3vZPFNpSCK+DJxc=";
          })

          # Java
          redhat.java
          vscjava.vscode-java-debug
          vscjava.vscode-java-dependency
          vscjava.vscode-maven

          # C#
          ms-dotnettools.csharp

          # Protos
          zxh404.vscode-proto3

          # Rust
          rust-lang.rust-analyzer
          tamasfe.even-better-toml

          # Python
          ms-python.python
        ]);
      })

      pkgs.nixpkgs-fmt # Used by the Nix IDE extension
    ];
  };
}
