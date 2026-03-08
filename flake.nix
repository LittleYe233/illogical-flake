{
  description = "Illogical Impulse - Home-manager module for end-4's Hyprland dotfiles with QuickShell";

  inputs = {
    # These will be overridden by the user's flake
    nixpkgs.url = "git+http://mirror.nju.edu.cn/git/nixpkgs.git?ref=nixos-unstable&shallow=1";

    quickshell = {
      url = "git+https://git.outfoxxed.me/quickshell/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Default dotfiles - can be overridden by users
    dotfiles = {
      url = "git+https://github.com/LittleYe233/dots-hyprland?submodules=1";
      flake = false;
    };
  };

  outputs = inputs@{ self, nixpkgs, quickshell, nur, dotfiles, ... }:
    let
      flakeInputs = { inherit quickshell nur dotfiles; };
    in {
      # Home-manager module for user configuration
      homeManagerModules.default = { config, lib, pkgs, ... }: (import ./home-module.nix) {
        inherit config lib pkgs;
        inputs = flakeInputs;
      };
      homeManagerModules.illogical-flake = self.homeManagerModules.default;
    };
}
