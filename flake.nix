{
  description = "Illogical Impulse - Home-manager module for end-4's Hyprland dotfiles with QuickShell";

  inputs = {
    # These will be overridden by the user's flake
    nixpkgs.url = "git+http://mirrors.tuna.tsinghua.edu.cn/git/nixpkgs.git?ref=nixos-unstable&shallow=1";

    quickshell = {
      url = "git+https://git.outfoxxed.me/quickshell/quickshell?rev=41651d7dcd62a9400eb6f4f8a8580efe00901efb";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    packages = {
      url = "git+https://codeberg.org/LittleYe233/packages.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Default dotfiles - can be overridden by users
    dotfiles = {
      url = "git+https://github.com/LittleYe233/dots-hyprland?submodules=1";
      flake = false;
    };
  };

  outputs = inputs@{ self, nixpkgs, quickshell, nur, dotfiles, packages, ... }:
    let
      flakeInputs = { inherit (inputs) quickshell nur dotfiles packages; inherit self; };
    in {
      # Home-manager module for user configuration
      homeManagerModules.default = { config, lib, pkgs, ... }: (import ./home-module.nix) {
        inherit config lib pkgs;
        inputs = flakeInputs;
      };
      homeManagerModules.illogical-flake = self.homeManagerModules.default;
    };
}
