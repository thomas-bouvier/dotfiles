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
    dnsovertls = "false";
    dnssec = "false";

    # Configure dns0.eu with .local domain resolution
    extraConfig = ''
      [Resolve]
      DNS=86.54.11.13
      DNS=86.54.11.213
      DNS=2a13:1001::86.54.11.13
      DNS=2a13:1001::86.54.11.213
      # Allow local resolution to bypass encrypted DNS
      # Domains=~. local
    '';
  };
}
