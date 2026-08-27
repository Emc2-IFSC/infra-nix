{lib, inputs, ...}: {
  imports = [
    inputs.sops-nix.nixosModules.sops
    ./hardware-configuration.nix
    #./services
    ../common/common.nix
  ];

  networking = {
    hostName = "museu";
    #useDHCP = true;
    domain = "";
  };

  # nixos-infect generated config below

  # Workaround for https://github.com/NixOS/nix/issues/8502
  services.logrotate.checkConfig = false;

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  
  users.users.root.openssh.authorizedKeys.keys = import ../keys.nix;

  system.stateVersion = "23.11";
}