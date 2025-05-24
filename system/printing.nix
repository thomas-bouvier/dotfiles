{ config, pkgs, ... }:

{
  services.printing.drivers = [ pkgs.cnijfilter2 ];
}
