{ pkgs, lib, ... }: {
  boot.kernelPackages = pkgs.linuxPackages_hardened;

  environment.systemPackages = [
    pkgs.curl
    pkgs.git 
  ];
 

  nix = {
    gc = {
      automatic = lib.mkDefault true;
      dates = lib.mkDefault "weekly";
      options = "-d --delete-older-than 30d";
    };
    settings = {
      experimental-features = ["nix-command" "flakes"];
      trusted-users = ["root" "@wheel"];
      auto-optimise-store = true;
      flake-registry = "";
    };
    extraOptions = "experimental-features = nix-command flakes";
  };

  nixpkgs.config.allowUnfree = true;

  services = {
    openssh = {
      enable = true;
      ports = [
        22
        # Precisamos de outra porta, pois a 22 só é acessível dentro da USP
        22001
        22002
      ];
      settings = {
        PasswordAuthentication = false;
      };
    };
  };

  users = {
    mutableUsers = false;
    users = {
      admin = {
        isNormalUser = true;
        extraGroups = ["wheel"];
        openssh.authorizedKeys.keys = import ../keys.nix;
        initialPassword = "12341234";
      };
    };
  };

  # Sudo sem senha
  security.sudo.extraConfig = "%wheel ALL = (ALL) NOPASSWD: ALL";

  boot.loader.grub = {
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_TIME = "pt_BR.UTF-8";
    };
  };

  time.timeZone = "America/Sao_Paulo";
}