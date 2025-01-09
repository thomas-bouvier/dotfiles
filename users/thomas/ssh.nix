{ pkgs, ... }:
{
  programs.ssh = {
    enable = true;

    matchBlocks = {
      "github" = {
        host = "github.com";
        identitiesOnly = true;
        identityFile = [
          "~/.ssh/id_ed25519"
        ];
      };

      "g5k" = {
        host = "g5k";
        user = "tbouvier";
        hostname = "access.grid5000.fr";
        forwardAgent = false;
      };
  
      "*.g5k" = {
        host = "*.g5k";
        user = "tbouvier";
        proxyCommand = "ssh g5k -W \"$(basename %h .g5k):%p\"";
        forwardAgent = false;
      };

      "access.g5k" = {
        host = "!access.grid5000.fr *.grid5000.fr";
        proxyCommand = "ssh -A tbouvier@194.254.60.33 -W \"$(basename %h):%p\"";
        user = "tbouvier";
        forwardAgent = true;
      };
    };
  };
}
