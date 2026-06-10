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

    tuigreet.url = "github:NotAShelf/tuigreet";

    llm-agents.url = "github:numtide/llm-agents.nix";

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
    pkgs = nixpkgs.legacyPackages.${system};
    pkgs-stable = import nixpkgs-stable {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    # nixpkgs.overlays = [ inputs.niri.overlays.niri ];

    devShells.${system}.default = pkgs.mkShell {
      buildInputs = with pkgs; [nixd statix];
    };

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
        inherit inputs pkgs-stable;
        llmAgents = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
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
