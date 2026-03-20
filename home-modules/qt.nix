inputs:

{ config, lib, pkgs, ... }:

let
  cfg = config.programs.illogical-impulse;
  pythonEnv = cfg.internal.pythonEnv;
  
  # The raw QuickShell package
  qsPackage = inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default;
  
  # Custom packages
  customPkgs = import ../pkgs { inherit pkgs; };
in
{
  config = lib.mkIf cfg.enable {
    home.packages = [ 
      # WRAPPED QuickShell (named "qs" to match config expectation)
      # This replaces the raw package to avoid collisions and force environment
      (pkgs.writeShellScriptBin "qs" ''
        # Comprehensive XDG_DATA_DIRS for icon and desktop file discovery
        export XDG_DATA_DIRS="${lib.makeSearchPath "share" [ 
          pkgs.adwaita-icon-theme 
          pkgs.hicolor-icon-theme 
          pkgs.papirus-icon-theme
          customPkgs.illogical-impulse-oneui4-icons
          pkgs.gnome-icon-theme
          pkgs.kdePackages.breeze-icons
          pkgs.lxqt.pavucontrol-qt
          pkgs.pavucontrol
        ]}:$HOME/.nix-profile/share:$HOME/.local/share:/etc/profiles/per-user/$USER/share:/run/current-system/sw/share:/usr/share:$XDG_DATA_DIRS"
        
        export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
        export QT_QPA_PLATFORMTHEME=gtk3
        
        # Launch the real binary
        exec ${qsPackage}/bin/qs "$@"
      '')
      pythonEnv
    ];
  };
}
