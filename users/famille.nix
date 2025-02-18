{ pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.famille = {
    isNormalUser = true;
    initialPassword = "pw123";
    extraGroups = [ "networkmanager" ];
  };

  # https://github.com/nix-community/home-manager/issues/4199
  system.userActivationScripts = {
    removeConflictingFiles = {
      text = ''
        rm -f /home/famille/.gtkrc-2.0.bak
      '';
    };
  };

  # Home-manager configuration
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bak";

    users.famille = import ./famille;
  };
}
