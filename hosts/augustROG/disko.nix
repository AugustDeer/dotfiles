{
  disko.devices.disk.main = {
    type = "disk";
    device = "/dev/disk/by-id/nvme-MTFDKBA2T0QFM-1BD1AABGB_242349688D59";
    content = {
      type = "gpt";
      partitions = {
        ESP = {
          type = "EF00";
          size = "1G";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [
              "fmask=0077"
              "dmask=0077"
            ];
          };
        };
        root = {
          size = "100%";
          content = {
            type = "luks";
            name = "cryptroot";
            content = {
              type = "btrfs";
              mountpoint = "/";
              subvolumes = {
                "/home" = {
                  mountpoint = "/home";
                };
                "/nix" = {
                  mountpoint = "/nix";
                };
              };
            };
          };
        };
        swap = {
          size = "32G";
          content = {
            type = "luks";
            name = "cryptswap";
            content = {
              type = "swap";
            };
          };
        };
      };
    };
  };
}
