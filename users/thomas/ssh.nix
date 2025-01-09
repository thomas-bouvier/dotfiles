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

      # Allows to securely use local SSH agent to authenticate on the remote machine.
      # It has the same effect as adding cli option `ssh -A user@host`
      "local" = {
        host = "192.168.*";
        user = "thomas";
        forwardAgent = true;
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
