{ ... }:

{
  networking = {
    networkmanager = {
      enable = true;
      # Ensure NetworkManager doesn't override DNS settings
      dns = "systemd-resolved";
    };

    firewall = {
      enable = true;

      # Localsend: port 53317
      # CUPS: port 631
      # mDNS: port 5353
      allowedTCPPorts = [ 53317 631 ];
      allowedUDPPorts = [ 53317 631 5353 ];
    };
  };

  services.resolved = {
    enable = true;
    # Disable because of https://github.com/systemd/systemd/issues/38509
    dnsovertls = "false";
    dnssec = "false";

    # Configure dns0.eu with .local domain resolution
    extraConfig = ''
      [Resolve]
      DNS=193.110.81.0#dns0.eu
      DNS=2a0f:fc80::#dns0.eu
      DNS=185.253.5.0#dns0.eu
      DNS=2a0f:fc81::#dns0.eu
      # Allow local resolution to bypass encrypted DNS
      # Domains=~. local
    '';
  };
}
