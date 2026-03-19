{ pkgs ? import <nixpkgs> {} }:

# Reference: https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=38c3-styles
# Reference: https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=ttf-readex-pro

let
  inherit (pkgs) lib stdenvNoCC fetchurl fetchFromGitHub symlinkJoin unzip;

in rec {
  space-grotesk-fonts = stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "space-grotesk-fonts";
    version = "2";

    src = fetchurl {
      url = "https://events.ccc.de/congress/2024/infos/styleguide/38c3-styleguide-full-v${finalAttrs.version}.zip";
      sha256 = "9ae65abcfc85c97a95bf64e70e9f5a0aba7948eea1d56a5a99a5feed727f5216";
    };

    nativeBuildInputs = [ unzip ];

    sourceRoot = ".";

    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/fonts/{opentype,woff,woff2}
      cp fonts/space-grotesk-1.1.4/otf/*.otf $out/share/fonts/opentype/
      cp fonts/space-grotesk-1.1.4/webfont/*.woff $out/share/fonts/woff/
      cp fonts/space-grotesk-1.1.4/webfont/*.woff2 $out/share/fonts/woff2/

      runHook postInstall
    '';

    meta = with lib; {
      description = "Space Grotesk fonts (including OTF & WOFF)";
      homepage = "https://events.ccc.de/congress/2024/infos/styleguide.html";
      license = licenses.ofl;
      platforms = platforms.all;
    };
  });

  readex-pro-fonts = stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "readex-pro-fonts";
    # Major version code is from README changelog.
    # Date is from authored date of specific commit.
    version = "1.2-20250214";

    src = fetchFromGitHub {
      owner = "ThomasJockin";
      repo = "readexpro";
      rev = "563dfbb36ae45e52ec50829b016ce724ac2fca70";
      hash = "sha256-+CLym2N2O6Opv7pxuVA+sfiENggPD5HRJrVByzaMMN8=";
    };

    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/fonts/truetype
      cp fonts/ttf/*.ttf $out/share/fonts/truetype/

      runHook postInstall
    '';

    meta = with lib; {
      description = "Readex Pro fonts";
      homepage = "https://github.com/ThomasJockin/readexpro";
      license = licenses.ofl;
      platforms = platforms.all;
    };
  });

  ### Bundle
  default = symlinkJoin {
    name = "custom-fonts-bundle";
    paths = [
      space-grotesk-fonts
      readex-pro-fonts
    ];
  };
}
