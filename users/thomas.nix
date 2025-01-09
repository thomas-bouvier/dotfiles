{ pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.thomas = {
    isNormalUser = true;
    initialPassword = "pw123";
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIwyCOXTY+2S+UlllvyKqU9qx0fyvWICHRiduOR2Kwxx contact@thomas-bouvier.io"
    ];
  };

  # Adding trusted users is required for devenv.
  # A list of names of users that have additional rights when connecting
  # to the Nix daemon, such as the ability to specify additional binary
  # caches. You can also specify groups by prefixing them with @; for
  # instance, @wheel means all users in the wheel group.
  nix.extraOptions = ''
    trusted-users = root thomas
  '';

  # Home-manager configuration
  home-manager = {
    users.thomas = import ./thomas;
  };
}
