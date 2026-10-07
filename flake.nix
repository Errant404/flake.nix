{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    llm-agents.url = "github:numtide/llm-agents.nix";
  };
  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      ...
    }@inputs:
    {
      nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
        };
        modules = [
          ./hosts/nixos
          home-manager.nixosModules.home-manager
          inputs.sops-nix.nixosModules.sops
          inputs.nix-flatpak.nixosModules.nix-flatpak
          {
            nixpkgs.overlays = [
              inputs.nur.overlays.default
              (final: _: {
                unstable = import inputs.nixpkgs-unstable {
                  inherit (final.stdenv.hostPlatform) system;
                  inherit (final) config;
                };
              })
              (final: _: {
                llm-agents = inputs.llm-agents.packages.${final.stdenv.hostPlatform.system};
              })
            ];
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.sharedModules = [
              inputs.nix-flatpak.homeManagerModules.nix-flatpak
            ];
            home-manager.users."errant".imports = [ ./home ];
          }
        ];
      };
    };
}
