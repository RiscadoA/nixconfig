{ pkgs, ... }:
{
  # Modules configuration.
  modules = {
    xdg.enable = true;

    shell = {
      lf.enable = true;
      git.enable = true;
      ssh.enable = true;
      zsh.enable = true;
      vim.enable = true;
    };
  };

  # Extra packages.
  home.packages = with pkgs; [
    htop
    libqalculate
    ripgrep
  ];
}
