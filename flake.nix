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

    # niri.url = "github:sodiboo/niri-flake";
    niri.url = "github:epireyn/niri-flake";

    tuigreet.url = "github:NotAShelf/tuigreet";

    llm-agents.url = "github:numtide/llm-agents.nix";

    spotify-player = {
      url = "github:aome510/spotify-player?ref=598777791a96fe35cf2c2cce4cbe8bfefb7cbbd9";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    pkgs-stable = import nixpkgs-stable {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    # nixpkgs.overlays = [ inputs.niri.overlays.niri ];

    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs system pkgs-stable;
      };

      modules = [
        ./nixos/configuration.nix
        inputs.stylix.nixosModules.stylix
        inputs.niri.nixosModules.niri
        # { nixpkgs.overlays = []; }
      ];
    };

    homeConfigurations.${user} = home-manager.lib.homeManagerConfiguration {
      pkgs = pkgs;
      extraSpecialArgs = {
        inherit pkgs-stable;
        llmAgents = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
        neovim-nightly = inputs.neovim-nightly.packages.${pkgs.stdenv.hostPlatform.system}.default;
        spotify-player = inputs.spotify-player.defaultPackage.${pkgs.stdenv.hostPlatform.system};
        helium = inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default;
        cohle = inputs.cohle.packages.${pkgs.stdenv.hostPlatform.system}.default;
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
