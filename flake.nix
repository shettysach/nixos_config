{
  description = "NixOS config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # niri.url = "github:sodiboo/niri-flake";
    niri = {
      url = "github:epireyn/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    llm-agents.url = "github:numtide/llm-agents.nix";

    neovim-nightly = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spotify-player = {
      url = "github:aome510/spotify-player";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spotifast = {
      url = "github:crmne/spotifast/77339ee47bf45f193e00b864a66a42401d63a93b";
      inputs.nixpkgs.url = "github:NixOS/nixpkgs/f20cd90e28fe0403873f473b29e42662cd86e8c4";
      inputs.rust-overlay.url = "github:oxalica/rust-overlay/dc2fd1acc537f3583744e1373597a5731ff7a6e3";
    };

    helium = {
      url = "github:amaanq/helium-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dankcalendar = {
      url = "github:AvengeMedia/dankcalendar";
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
        spotifast = inputs.spotifast.packages.${pkgs.stdenv.hostPlatform.system}.default;
        helium = inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.helium;
        cohle = inputs.cohle.packages.${pkgs.stdenv.hostPlatform.system}.default;
      };

      modules = [
        ./home-manager/home.nix
        inputs.stylix.homeModules.stylix
        inputs.niri.homeModules.niri
        inputs.niri.homeModules.stylix
        inputs.dankcalendar.homeModules.dank-calendar
      ];
    };
  };
}
