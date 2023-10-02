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
in
{
  options.modules.desktop.apps.vscode.enable = mkEnableOption "vscode";

  config = mkIf cfg.enable {
    home.packages = [
      (pkgs.unstable.vscode-with-extensions.override {
        vscodeExtensions = (with pkgs.unstable.vscode-extensions; [
          mkhl.direnv
          github.copilot
          ms-vscode-remote.remote-ssh
          ms-vsliveshare.vsliveshare

          # Theme
          file-icons.file-icons

          # Git
          mhutchie.git-graph
          waderyan.gitblame

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
          
          # C++
          ms-vscode.cpptools
          ms-vscode.cmake-tools

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
    ];
  };
}
