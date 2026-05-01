{ pkgs, lib, ... }: {
  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_hardened;

  environment.systemPackages = [
    pkgs.curl
    pkgs.git 
  ];
 

  nix = {
    gc = {
      automatic = lib.mkDefault true;
      dates = lib.mkDefault "weekly";
      options = lib.mkDefault "-d --delete-older-than 90d";
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
      enable = lib.mkDefault true;
      ports = lib.mkDefault [
        22
        # Precisamos de outra porta, pois a 22 só é acessível dentro da USP
        22001
        22002
      ];
      settings = {
        PasswordAuthentication = lib.mkDefault false;
      };
    };
  };

  users = {
    mutableUsers = lib.mkDefault false;
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

  i18n = {
    defaultLocale = lib.mkDefault "en_US.UTF-8";
    extraLocaleSettings = {
      LC_TIME = lib.mkDefault "pt_BR.UTF-8";
    };
  };

  time.timeZone = "America/Sao_Paulo";
}