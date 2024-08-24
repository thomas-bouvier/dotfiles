{ config, ... }:
{
  home.file.".zsh/aliases.zsh".source = ./assets/aliases.zsh;

  programs.zsh = {
    enable = true;

    initExtra = ''
      autoload -Uz vcs_info # enable vcs_info
      precmd () { vcs_info } # always load before displaying the prompt
      setopt prompt_subst
      #PS1='%n@%m %F{red}%/%f$vcs_info_msg_0_ $ '
      PS1="%3~ ''${vcs_info_msg_0_}%# "

      eval "$(atuin init zsh)"

      # Source everything from ~/.zsh/*.zsh
      for f ("$HOME"/.zsh/*.zsh) . $f
    '';
  };
}
