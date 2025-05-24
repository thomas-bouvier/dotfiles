{ ... }:

{
  networking = {
    networkmanager.enable = true;

    firewall = {
      enable = true;

      # Localsend: port 53317
      # CUPS: port 631
      # mDNS: port 5353
      allowedTCPPorts = [ 53317 631 ];
      allowedUDPPorts = [ 53317 631 5353 ];
    };

    # Use dns0.eu
    # Break LocalSend which can't receive files anymore when enabled
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
