{ pkgs, ... }:
{
  programs.ssh = {
    enable = true;

    matchBlocks = {
      "hosts" = {
        host = "github.com";
        identitiesOnly = true;
        identityFile = [
          "~/.ssh/id_ed25519"
        ];
      };
    };

    extraConfig = ''
      Host g5k
        User tbouvier
        Hostname access.grid5000.fr
        ForwardAgent no
      Host *.g5k
        User tbouvier
        ProxyCommand ssh g5k -W "$(basename %h .g5k):%p"
        ForwardAgent no
      Host !access.grid5000.fr *.grid5000.fr
        ProxyCommand ssh -A tbouvier@194.254.60.33 -W "$(basename %h):%p"
        User tbouvier
        ForwardAgent yes
    '';
  };
}
