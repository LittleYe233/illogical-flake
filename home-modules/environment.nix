inputs:

{ config, lib, pkgs, ... }:

let
  cfg = config.programs.illogical-impulse;

  # Common Qt dependencies for QuickShell and KDE applications
  qtModules = with pkgs.kdePackages; [
    qtbase
    qtdeclarative
    qtsvg
    qtwayland
    qt5compat
    qtimageformats
    qtmultimedia
    qtpositioning
    qtsensors
    qtquicktimeline
    qttools
    qttranslations
    qtvirtualkeyboard
    qtwebsockets
    syntax-highlighting
    kirigami.unwrapped
    kirigami-addons
    bluedevil
    bluez-qt
    plasma-nm
    libplasma
    ksvg
    plasma-workspace
    kcmutils
  ] ++ [ pkgs.qt6Packages.qt6ct ];
in
{
  config = lib.mkIf cfg.enable {
    # Environment variables for Illogical Impulse
    home.sessionVariables = {
      ILLOGICAL_IMPULSE_DOTFILES_SOURCE = "${config.home.homeDirectory}/.config";
      ILLOGICAL_IMPULSE_VIRTUAL_ENV = "${config.home.homeDirectory}/.local/state/quickshell/.venv";
      qsConfig = "${config.home.homeDirectory}/.config/quickshell/ii";

      # Qt environment variables for non-KDE environments (like Hyprland)
      # This ensures that KDE applications (like systemsettings) and QuickShell can find their QML modules and plugins
      QML2_IMPORT_PATH = "${lib.makeSearchPath "lib/qt-6/qml" qtModules}:${config.home.homeDirectory}/.nix-profile/lib/qt-6/qml:/run/current-system/sw/lib/qt-6/qml";

      QT_PLUGIN_PATH = "${lib.makeSearchPath "lib/qt-6/plugins" qtModules}:${lib.makeSearchPath "lib/qt6/plugins" qtModules}:${lib.makeSearchPath "lib/plugins" qtModules}:${config.home.homeDirectory}/.nix-profile/lib/qt-6/plugins:${config.home.homeDirectory}/.nix-profile/lib/plugins:/run/current-system/sw/lib/qt-6/plugins";
    };
    
    # Ensure variables are available to systemd services (and Hyprland)
    systemd.user.sessionVariables = config.home.sessionVariables;

    # Install Qt modules and qt6ct for Qt theming
    home.packages = qtModules;
  };
}
