{
  config,
  inputs,
  ...
}:
{
  # Enable CUDA support for packages on machines with NVIDIA GPUs
  nixpkgs = {
    config = {
      cudaSupport = true;
      cudaForwardCompat = true;
    };

    overlays = [
      (_final: prev: {
        # Import onnxruntime from a clean nixpkgs evaluation without cudaSupport.
        # Using the flake's pinned nixpkgs input ensures the derivation hash
        # matches the binary cache, avoiding source rebuilds of onnxruntime and
        # its reverse dependencies (e.g. librewolf).
        #
        # Why this is needed: `prev.onnxruntime.override { cudaSupport = false; }`
        # does NOT produce a cache-matching derivation because the override is
        # applied within a package set where cudaSupport=true globally, which
        # taints transitive dependencies.
        onnxruntime =
          (import inputs.nixpkgs {
            inherit (prev) system;
            config = { };
          }).onnxruntime;
      })
    ];
  };

  # Enable OpenGL
  hardware.graphics = {
    enable = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
    # of just the bare essentials.
    powerManagement.enable = true;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the Nvidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    open = false;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
  };
}
