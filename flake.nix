{
  description = "NixOS config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    inherit (self) outputs;
  in {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#hostname'
    nixosConfigurations = {

      museu = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
		      ./museu/configuration.nix # Our main nixos configuration file
	      ];
      };

      pc-mini-1-200154879 = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
		      ./pcs-mini/pc-mini-1-200154879/configuration.nix # Our main nixos configuration file
	      ];
      };

      totem-vemsaber-1 = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
		      ./totens-vem-saber/1.nix
	      ];
      };

      totem-vemsaber-2 = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
		      ./totens-vem-saber/2.nix
	      ];
      };

      totem-vemsaber-3 = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
		      ./totens-vem-saber/3.nix
	      ];
      };

      totem-vemsaber-4 = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
		      ./totens-vem-saber/4.nix
	      ];
      };

    };
  };
}