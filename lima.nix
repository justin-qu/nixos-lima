{
  config,
  modulesPath,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    ./lima-init.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Get image under 2GB for Github release.
  documentation.enable = false;

  # Give users in the `wheel` group additional rights when connecting to the Nix daemon
  # This simplifies remote deployment to the instance's nix store.
  nix.settings.trusted-users = [ "@wheel" ];

  # Read Lima configuration at boot time and run the Lima guest agent
  services.lima.enable = true;

  # ssh
  services.openssh.enable = true;

  security = {
    sudo = {
      enable = true;
      wheelNeedsPassword = false;
    };
  };

  # system mounts
  boot = {
    kernelParams = [ "console=tty0" ];
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };
  };
  fileSystems = {
    "/".options = [
      "discard"
      "noatime"
      "nodiratime"
    ];
    "/boot".options = [
      "discard"
      "noatime"
      "umask=0077"
    ];
  };

  # pkgs
  environment.systemPackages = with pkgs; [
    vim
    git
    htop
    direnv
    nix-output-monitor
  ];

  programs = {
    direnv = {
      enable = true;
      silent = true;
    };
  };

  system.stateVersion = "25.11";

  virtualisation.rosetta = {
    enable = true;
    mountTag = "vz-rosetta";
  };
}
