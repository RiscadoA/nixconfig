# modules/home/shell/vim.nix
#
# Author: Ricardo Antunes <me@riscadoa.com>
# URL:    https://github.com/RiscadoA/nixconfig
#
# Vim home configuration.

{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.shell.vim;
in {
  options.modules.shell.vim.enable = mkEnableOption "vim";

  config = mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      vimAlias = true;
      withPython3 = true;
      plugins = with pkgs.vimPlugins; [
        vim-nix
        vimwiki
        gruvbox
      ];
      extraConfig = ''
        let g:vimwiki_list = [{'path': '~/documents/wiki'}]
        let g:vimwiki_global_ext = 0
      '';
    };

    home.sessionVariables = {
      EDITOR = "vim";
    };

    home.shellAliases = {
      wiki = "vim -c :VimwikiIndex";
    };
  };
}
