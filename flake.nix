{
  description = "NixOS config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";

    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri.url = "github:sodiboo/niri-flake";
    spot.url = "github:aome510/spotify-player/1ba220a5ee38e912075d05c25c25025ad74d6459";

    helium = {
      url = "github:amaanq/helium-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    cohle = {
      url = "github:shettysach/cohle";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    nixpkgs-stable,
    home-manager,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    user = "sword";
  in {
    # nixpkgs.overlays = [ inputs.niri.overlays.niri ];

    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs system;

        pkgs-stable = import nixpkgs-stable {
          inherit system;
          config.allowUnfree = true;
        };
      };

      modules = [
        ./nixos/configuration.nix
        inputs.stylix.nixosModules.stylix
        inputs.niri.nixosModules.niri
        # { nixpkgs.overlays = []; }
      ];
    };

    homeConfigurations.${user} = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${system};
      extraSpecialArgs = {
        spotMain = inputs.spot.defaultPackage.${system}.override {withAudioBackend = "pulseaudio";};
      };

      modules = [
        ./home-manager/home.nix
        inputs.stylix.homeModules.stylix
        inputs.niri.homeModules.niri
        inputs.niri.homeModules.stylix
      ];
    };
  };
}
