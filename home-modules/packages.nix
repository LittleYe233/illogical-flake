inputs:

{ config, lib, pkgs, ... }:

let
  cfg = config.programs.illogical-impulse;

  # Custom packages
  customPkgs = import ../pkgs { inherit pkgs; };

  # Python environment for quickshell wallpaper analysis
  pythonEnv = pkgs.python3.withPackages (ps: with ps; [
    build
    cffi
    click
    dbus-python
    ipython
    (ps."kde-material-you-colors".overridePythonAttrs (old: {
      propagatedBuildInputs = (old.propagatedBuildInputs or []) ++ [ python-magic ];
    }))
    libsass
    loguru
    material-color-utilities
    materialyoucolor
    numpy
    pillow
    psutil
    pycairo
    pygobject3
    pywayland
    setproctitle
    setuptools-scm
    tqdm
    wheel
    pyproject-hooks
    opencv4
  ]);
in
{
  # Export pythonEnv for use in other modules
  options.programs.illogical-impulse.internal.pythonEnv = lib.mkOption {
    type = lib.types.package;
    internal = true;
    default = pythonEnv;
  };

  # See dots-hyprland/sdata/dist-nix/home-manager/home.nix to check out packages
  config = lib.mkIf cfg.enable {
    # User packages for Illogical Impulse
    home.packages = with pkgs; [
      ##### Sure #####
      inetutils # provides hostname, ifconfig, ping, etc.
      libnotify # provides notify-send

      #dbus
      xlsclients # list client apps on X11 (still needed?)
      kdePackages.kconfig # provides kwriteconfig6 used in install script (still needed?)

      ##### Deps from illogical-impulse AUR pkgs #####
      ### audio
      libcava # provides & replaces cava
      lxqt.pavucontrol-qt # provides pavucontrol-qt
      wireplumber # provides wireplumber
      # Has been installed system-wide
      #pipewire # provides pipewire-pulse and many
      libdbusmenu-gtk3
      playerctl # provides playerctl (controls media players)

      ### backlight
      # geoclue2 has been installed system-wide
      brightnessctl # provides brightnessctl
      ddcutil # provides ddcutil

      ### basic
      bc # provides bc (GNU calc)
      uutils-coreutils-noprefix # provides coreutils (Rust rewrite)
      cliphist # provides cliphist
      cmake # provides cmake
      # Both should be installed.
      #curlFull # provides curl
      #wget # provides wget
      ripgrep # provides rg
      jq # provides jq
      xdg-user-dirs # provides xdg-user-dirs
      rsync # provides rsync
      yq-go # provides yq (CLI YAML processor)

      ### bibata-modern-classic-bin
      bibata-cursors # cursor theme

      ### fonts-themes
      adwaita-icon-theme # GNOME fallback icons
      adw-gtk3 # libadwaita port
      kdePackages.breeze # breeze
      kdePackages.breeze-icons # breeze
      customPkgs.breeze-plus-icons # third-party breeze-plus icon set 
      darkly # Qt style, provides darkly-settings6
      darkly-qt5 # Qt style
      eza # provides eza
      #fish # provides fish
      fontconfig # provides fc-*
      matugen # provides matugen
      customPkgs.custom-fonts.default # Provides space grotesk and readex pro
      #nerd-fonts.jetbrains-mono
      material-symbols # Google Material symbols icons
      #rubik
      twemoji-color-font # Color emoji SVGinOT font using Twitter Unicode 10

      ### hyprland
      #hyprland
      hyprsunset # provides hyprsunset
      wl-clipboard # provides wl-copy/-paste

      ### kde
      kdePackages.bluedevil # Bluetooth management (for kcm_bluetooth)
      # Both enabled as service system-wide
      #gnome-keyring # provides gnome-keyring
      #networkmanager
      kdePackages.plasma-nm # Network management (for kcm_networkmanagement)
      kdePackages.polkit-kde-agent-1 # Polkit authentication agent # NOTE: Hope it works in user-wide
      kdePackages.dolphin
      kdePackages.systemsettings

      ## Optional pkgs
      kdePackages.plasma-workspace # provides plasma-apply-colorscheme
      (pkgs.writeShellScriptBin "plasma-changeicons" ''
        exec ${pkgs.kdePackages.plasma-workspace}/libexec/plasma-changeicons "$@"
      '') # expose `plasma-changeicons` command to satisfy switchwall.sh
      kdePackages.kde-cli-tools # Provides various KDE CLI utilities
      kdePackages.kdialog # Dialog prompts
      #kdePackages.kirigami
      kdePackages.plasma-integration # Needed for kde theming
      libsForQt5.qtstyleplugin-kvantum # Needed for Qt5 theming
      kdePackages.ark
      kdePackages.okular

      ### microtex-git
      customPkgs.illogical-impulse-microtex

      ### oneui4-icons-git
      customPkgs.illogical-impulse-oneui4-icons

      ### portal
      # Included elsewhere

      ### python
      #clang # NOTE: no such pkg? no need?
      uv # provides uv
      gtk4
      libadwaita
      libsoup_3 # GNOME HTTP C/S library
      libportal-gtk4 # Flatpak portal library
      gobject-introspection # Programming language middleware layer

      ### quickshell-git
      # No need certainly

      ### screencapture
      hyprshot # provides hyprshot
      grim # not in dist-arch but may be an optional alternative
      slurp # provides slurp
      swappy # provides swappy
      tesseract # provides tesseract
      customPkgs.tesseract-data.eng
      wf-recorder # provides wf-recorder

      ### toolkit
      upower # provides upower
      wtype # provides wtype (xdotool type for wayland)
      ydotool # provides ydotool(d) (CLI automation tool)

      ### widgets
      fuzzel # provides fuzzel
      glib # GLib 2
      imagemagick # provides magick and more
      hypridle # provides hypridle
      # Installed system-wide
      #hyprlock # provides hyprlock
      hyprpicker # provides hyprpicker
      songrec # provides songrec
      translate-shell # provides trans (translation CLI)
      wlogout # provides wlogout
      libqalculate # provides qalc (advanced calc library)

      ##### Other optionals #####
      pulseaudio # provides pactl and parec for audio recording
      gnome-settings-daemon # provides gsettings
      gsettings-desktop-schemas # collection of gsettings schemas
      easyeffects # provides easyeffects (pipewire audo effects)
      wayland-protocols
      sassc # provides sassc (front-end libsass)
      papirus-icon-theme # primary icon theme
      hicolor-icon-theme # base icon theme (required by most themes)
      gnome-icon-theme # additional GNOME icon coverage
      kdePackages.plasma-systemmonitor
      kdePackages.kcmutils
      
      # Python with required packages for wallpaper analysis
      pythonEnv

      # Additional Qt support
      libsForQt5.qtgraphicaleffects
      libsForQt5.qtsvg

      # For quickshell key store
      libsecret
    ] ++ lib.optionals cfg.dotfiles.fish.enable [
      fish
    ] ++ lib.optionals cfg.dotfiles.kitty.enable [
      kitty
    ] ++ lib.optionals cfg.dotfiles.starship.enable [
      starship
    ];
  };
}
