{
  disko.devices = {
    disk = {
      main = {
        destroy = false;
        type = "disk";
        device = "/dev/nvme0n1"; # adapt if needed

        content = {
          type = "gpt";

          partitions = {
            #
            # WARNING
            # For an Apple Silicon machine, all UUIDs should match
            # ls /dev/disk/by-partuuid/
            #

            iBootSystemContainer = {
              label = "iBootSystemContainer";
              priority = 1;
              type = "AF0B";
              uuid = "bd594f64-97a1-4481-9f9d-f9299b6441bc";
            };

            Container = {
              label = "Container";
              priority = 2;
              type = "AF0A";
              uuid = "7376358f-5361-4f84-98ab-f89cc97242da";
            };

            NixOSContainer = {
              priority = 3;
              type = "AF0A";
              uuid = "68f09c2b-fae3-4aae-93e4-c4b9ff77ef5a";
            };

            ESP = {
              uuid = "43c87b8a-4e99-4e5a-a3bf-b2b74e0f0888";
              priority = 4;
              # size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };

            RecoveryOSContainer = {
              label = "RecoveryOSContainer";
              priority = 5;
              type = "AF0C";
              uuid = "b98875db-4863-4aa5-85bd-760b5fefda66";
            };

            root = {
              size = "100%";

              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];
                subvolumes = {
                  "/root" = {
                    mountpoint = "/";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                  "/home" = {
                    mountpoint = "/home";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                  "/nix" = {
                    mountpoint = "/nix";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                  "/swap" = {
                    mountpoint = "/.swapfile";
                    swap.swapfile.size = "50G";
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
