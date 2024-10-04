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
          ms-vscode-remote.remote-ssh
          ms-vsliveshare.vsliveshare
          ms-vscode.hexeditor

          # Copilot
          (buildExtension {
            name = "copilot";
            publisher = "github";
            version = "1.194.885";
            sha256 = "sha256-rBWCvOWT0M5CEy9+ndWEr9z+O70UncKyMYnNipEZePo=";
          })
          (buildExtension {
            name = "copilot-chat";
            publisher = "github";
            version = "0.16.2024051702";
            sha256 = "sha256-u10WGo29lCi29sQJt3hAdD79OqgcUlIza1NCh4GyM4Y=";
          })

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

          # Groovy
          (buildExtension {
            name = "code-groovy";
            publisher = "marlon407";
            version = "0.1.2";
            sha256 = "sha256-8jR4miZL3m5344wGpQaQ8pJjGcm0A3+5gX99x+G5QL8=";
          })
          (buildExtension {
            name = "vscode-groovy-lint";
            publisher = "NicolasVuillamy";
            version = "3.2.1";
            sha256 = "sha256-CUzJyqZmUOtmaRAOsAV3PTkKzgGyyBXhT3T2mMES3cA=";
          })

          # C#
          ms-dotnettools.csharp

          # Coq
          (buildExtension {
            name = "vscoq";
            publisher = "maximedenes";
            version = "2.1.2";
            sha256 = "sha256-cjpDKrn1BhC66tNJM86cMuLrCWgxen+MfSIZ8cmzIDE=";
          })

          # Protos
          zxh404.vscode-proto3

          # Rust
          rust-lang.rust-analyzer
          tamasfe.even-better-toml

          # Python
          ms-python.python

          # Agda
          (buildExtension {
            name = "agda-mode";
            publisher = "banacorn";
            version = "0.4.7";
            sha256 = "sha256-gNa3n16lP3ooBRvGaugTua4IXcIzpMk7jBYMJDQsY00=";
          })
          (buildExtension {
            name = "agda";
            publisher = "j-mueller";
            version = "0.1.7";
            sha256 = "sha256-S0svSulHJKN7JwznVj3KTLd341oeMainUiY/peQdPSY=";
          })

          # Promela
          (buildExtension {
            name = "promela";
            publisher = "dsvictor94";
            version = "0.4.0";
            sha256 = "sha256-Jt188cui5bOk89u1Fd4v64ASxBf7/6iUKjQfzfqNNoc=";
          })

          # Dafny
          (buildExtension {
            name = "ide-vscode";
            publisher = "dafny-lang";
            version = "3.4.1";
            sha256 = "sha256-IgQkp7g7YCOVLb59AkH/NCulGEWB/+ZYIYxjYPLg8WY=";
          })

          # Shaders
          (buildExtension {
            name = "shader";
            publisher = "slevesque";
            version = "1.1.5";
            sha256 = "sha256-Pf37FeQMNlv74f7LMz9+CKscF6UjTZ7ZpcaZFKtX2ZM=";
          })
          (buildExtension {
            name = "vscode-glsllint";
            publisher = "dtoplak";
            version = "1.8.1";
            sha256 = "sha256-8awWoDcYUUnwUEHfwO8n9c8l2699/TWwO8Eg0ce2t6s=";
          })
          (buildExtension {
            name = "wgsl";
            publisher = "PolyMeilex";
            version = "0.1.17";
            sha256 = "sha256-vGqvVrr3wNG6HOJxOnJEohdrzlBYspysTLQvWuP0QIw=";
          })
        ]);
      })

      pkgs.nixpkgs-fmt # Used by the Nix IDE extension
      pkgs.glslang # Used by the GLSL Lint extension
    ];
  };
}
