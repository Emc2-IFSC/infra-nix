{lib, inputs, ...}: {
  imports = [
    inputs.sops-nix.nixosModules.sops
    ./hardware-configuration.nix
    #./services
    ../common/common.nix
  ];

  networking = {
    hostName = "museu";
    useDHCP = true;
  };

  system.stateVersion = "25.05";
}