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
  buildMarketplaceExtension = ({ name, publisher, version, sha256, buildInputs ? [ ] }:
    pkgs.unstable.vscode-utils.buildVscodeMarketplaceExtension {
      inherit buildInputs;
      mktplcRef = {
        inherit name publisher version sha256;
      };
    });
  buildLocalExtension = ({ name, publisher, version, vsix, buildInputs ? [ ] }:
    pkgs.unstable.vscode-utils.buildVscodeMarketplaceExtension {
      inherit buildInputs vsix;
      mktplcRef = {
        inherit name publisher version;
      };
    });
in
{
  options.modules.desktop.apps.vscode.enable = mkEnableOption "vscode";

  config = mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;
      mutableExtensionsDir = false;

      userSettings = {
        "window.customTitleBarVisibility" = "never";
        "window.dialogStyle" = "custom";
        "window.menuBarVisibility" = "compact";
        "window.titleBarStyle" = "custom";
        "extensions.ignoreRecommendations" = "true";
        "files.associations" = {
          "*.cmake.in" = "cmake";
        };
        "cmake.configureOnOpen" = "true";
      };

      package = pkgs.unstable.vscode;
      extensions = (with pkgs.unstable.vscode-extensions; [
        mkhl.direnv
        ms-vscode-remote.remote-ssh
        ms-vsliveshare.vsliveshare
        ms-vscode.hexeditor

        # Copilot
        (buildMarketplaceExtension {
          name = "copilot";
          publisher = "github";
          version = "1.194.885";
          sha256 = "sha256-rBWCvOWT0M5CEy9+ndWEr9z+O70UncKyMYnNipEZePo=";
        })
        (buildMarketplaceExtension {
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
        (buildMarketplaceExtension {
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
        (buildMarketplaceExtension {
          name = "code-groovy";
          publisher = "marlon407";
          version = "0.1.2";
          sha256 = "sha256-8jR4miZL3m5344wGpQaQ8pJjGcm0A3+5gX99x+G5QL8=";
        })
        (buildMarketplaceExtension {
          name = "vscode-groovy-lint";
          publisher = "NicolasVuillamy";
          version = "3.2.1";
          sha256 = "sha256-CUzJyqZmUOtmaRAOsAV3PTkKzgGyyBXhT3T2mMES3cA=";
        })

        # C#
        ms-dotnettools.csharp

        # Coq
        (buildMarketplaceExtension {
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
        vadimcn.vscode-lldb

        # Python
        ms-python.python

        # Agda
        (buildMarketplaceExtension {
          name = "agda-mode";
          publisher = "banacorn";
          version = "0.4.7";
          sha256 = "sha256-gNa3n16lP3ooBRvGaugTua4IXcIzpMk7jBYMJDQsY00=";
        })
        (buildMarketplaceExtension {
          name = "agda";
          publisher = "j-mueller";
          version = "0.1.7";
          sha256 = "sha256-S0svSulHJKN7JwznVj3KTLd341oeMainUiY/peQdPSY=";
        })

        # Promela
        (buildMarketplaceExtension {
          name = "promela";
          publisher = "dsvictor94";
          version = "0.4.0";
          sha256 = "sha256-Jt188cui5bOk89u1Fd4v64ASxBf7/6iUKjQfzfqNNoc=";
        })

        # Verifast
        (buildMarketplaceExtension {
          name = "verifast";
          publisher = "verifast";
          version = "0.9.2";
          sha256 = "sha256-zQiMaoeAYuvCD+W+Oxmt78dSRcVeUYy8ikcOhgJ0+Rw=";
        })

        # Shaders
        (buildMarketplaceExtension {
          name = "shader";
          publisher = "slevesque";
          version = "1.1.5";
          sha256 = "sha256-Pf37FeQMNlv74f7LMz9+CKscF6UjTZ7ZpcaZFKtX2ZM=";
        })
        (buildMarketplaceExtension {
          name = "vscode-glsllint";
          publisher = "dtoplak";
          version = "1.8.1";
          sha256 = "sha256-8awWoDcYUUnwUEHfwO8n9c8l2699/TWwO8Eg0ce2t6s=";
        })
        (buildMarketplaceExtension {
          name = "wgsl";
          publisher = "PolyMeilex";
          version = "0.1.17";
          sha256 = "sha256-vGqvVrr3wNG6HOJxOnJEohdrzlBYspysTLQvWuP0QIw=";
        })

        # CLASS
        (buildMarketplaceExtension {
          name = "class";
          publisher = "classlang";
          version = "1.2.0";
          sha256 = "sha256-R4dRmbWHdCLzk96zJvrCHTr3UqJ+yRmtqBuVYBlXs8s=";
        })

        # LATEX
        (buildMarketplaceExtension {
          name = "latex-workshop";
          publisher = "James-Yu";
          version = "10.5.6";
          sha256 = "sha256-49sxhmMVKUw+++7wGeK0G5rXNBBynf9SPU2at7TJ4tM=";
        })

        # Lua
        sumneko.lua
        
        # CSV
        (buildMarketplaceExtension {
          name = "rainbow-csv";
          publisher = "mechatroner";
          version = "3.17.0";
          sha256 = "sha256-qny0LU0+Q38H0BMC4Njk173KDuLjebxZN3Bg8vSDVLA=";
        })
      ]);
    };

    home.packages = with pkgs; [
      pkgs.nixpkgs-fmt # Used by the Nix IDE extension
      pkgs.glslang # Used by the GLSL Lint extension
    ];
  };
}
