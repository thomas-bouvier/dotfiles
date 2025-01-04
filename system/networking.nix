{ ... }:
{
  networking = {
    networkmanager.enable = true;

    firewall = {
      enable = true;

      # Localsend: port 53317
      allowedTCPPorts = [ 53317 ];
      allowedUDPPorts = [ 53317 ];
    };

    # Use dns0.eu
    nameservers = [
      "193.110.81.0#dns0.eu"
      "2a0f:fc80::#dns0.eu"
      "185.253.5.0#dns0.eu"
      "2a0f:fc81::#dns0.eu"
    ];
  };

  services.resolved = {
    enable = true;
    dnsovertls = "true";
  };
}
