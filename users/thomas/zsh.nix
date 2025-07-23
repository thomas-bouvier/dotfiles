{ config, ... }:
{
  home.file.".zsh/aliases.zsh".source = ./assets/aliases.zsh;

  programs.zsh = {
    enable = true;

    initContent = ''
      autoload -Uz vcs_info
      precmd() { vcs_info }
      setopt prompt_subst

      zstyle ':vcs_info:*' formats ' %s(%F{green}%b%f)' # git(main)
      PS1='%m %3~$vcs_info_msg_0_ $ '

      eval "$(atuin init zsh)"
      # Source everything from ~/.zsh/*.zsh
      for f ("$HOME"/.zsh/*.zsh) . $f
    '';
  };
}
