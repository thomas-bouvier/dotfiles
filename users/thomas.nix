{ pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.thomas = {
    isNormalUser = true;
    initialPassword = "pw123";
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
  };

  # Adding trusted users is required for devenv.
  # A list of names of users that have additional rights when connecting
  # to the Nix daemon, such as the ability to specify additional binary
  # caches. You can also specify groups by prefixing them with @; for
  # instance, @wheel means all users in the wheel group.
  nix.extraOptions = ''
    trusted-users = root thomas
  '';
}
