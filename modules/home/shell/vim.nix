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
in
{
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
        let g:vimwiki_list=[{'path': '~/documents/wiki', 'syntax': 'markdown', 'ext': '.md'}, {'path': '~/documents/wiki-shared', 'syntax': 'markdown', 'ext': '.md'}]
        let g:vimwiki_global_ext=0
        let g:vimwiki_folding='list'

        set tabstop=4
        set shiftwidth=4
        set softtabstop=4
        set expandtab
        set nowrap
      
        command! Diary VimwikiDiaryIndex
        augroup vimwikigroup
          autocmd!
          autocmd BufRead,BufNewFile diary.md VimwikiDiaryGenerateLinks
          autocmd BufNewFile ~/documents/wiki/diary/*.md :silent 0r !~/nixos/bin/diary-template.sh '%'
        augroup end
      '';
    };

    home.sessionVariables = {
      EDITOR = "vim";
    };

    home.shellAliases = {
      wiki = "vim -c :VimwikiIndex";
      diary = "vim -c :VimwikiMakeDiaryNote";
    };
  };
}
