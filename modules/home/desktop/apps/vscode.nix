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
          xaver.clang-format 
          ms-vscode.cpptools
          ms-vscode.cmake-tools
          (buildExtension {
            name = "cpptools-themes";
            publisher = "ms-vscode";
            version = "2.0.0";
            sha256 = "sha256-YWA5UsA+cgvI66uB9d9smwghmsqf3vZPFNpSCK+DJxc=";
          })

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
