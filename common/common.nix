{ pkgs, lib, ... }: {
  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages;

  environment.systemPackages = [
    pkgs.curl
    pkgs.git 
  ];

  # Zsh
  environment.shells = [ pkgs.zsh ];
  users.defaultUserShell = pkgs.zsh;
  programs.zsh = {
     enable = true;
     enableCompletion = true;
     autosuggestions.enable = true;
     syntaxHighlighting.enable = true;

    ohMyZsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "agnoster";
    };

    shellAliases = {
      cdn = "cd /home/admin/infra-nix";
    };
  };
 

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
    mutableUsers = lib.mkDefault true;
    users = {
      admin = {
        isNormalUser = true;
        extraGroups = ["wheel"];
        openssh.authorizedKeys.keys = import ../keys.nix;
        initialPassword = "12341234";
      };
    };
  };

  i18n = {
    defaultLocale = lib.mkDefault "en_US.UTF-8";
    extraLocaleSettings = {
      LC_TIME = lib.mkDefault "pt_BR.UTF-8";
    };
  };

  security.sudo.extraConfig = ''
    Defaults pwfeedback
  '';

  time.timeZone = "America/Sao_Paulo";
}