{ pkgs }:

{
  illogical-impulse-microtex = pkgs.callPackage ./illogical-impulse-microtex { };
  breeze-plus-icons = pkgs.callPackage ./breeze-plus-icons { };
  custom-fonts = pkgs.callPackage ./custom-fonts/default.nix { };
  tesseract-data = pkgs.callPackage ./tesseract-data/default.nix { };
}
