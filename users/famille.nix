{ pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.famille = {
    isNormalUser = true;
    initialPassword = "pw123";
    extraGroups = [ "networkmanager" ];
  };
}
