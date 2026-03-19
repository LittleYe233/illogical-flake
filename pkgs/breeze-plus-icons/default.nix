{
  stdenvNoCC,
  fetchFromGitHub,
  gtk3,
}:

stdenvNoCC.mkDerivation rec {
  pname = "breeze-plus-icons";
  version = "6.19.0";

  src = fetchFromGitHub {
    owner = "mjkim0727";
    repo = "breeze-plus";
    rev = version;
    hash = "sha256-Z/kb2Ysc9JHFo6/Xsaawlzf5EfB1wQeYiaPTv42CIEc=";
  };

  nativeBuildInputs = [
    gtk3
  ];

  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons
    cp -r src/breeze-plus* $out/share/icons/

    runHook postInstall
  '';
}
