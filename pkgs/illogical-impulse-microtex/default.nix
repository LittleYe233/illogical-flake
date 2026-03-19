{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  tinyxml-2,
  gtkmm3,
  gtksourceviewmm4, # identical to gtksourceviewmm in Arch repository
  cairomm,
}:

stdenv.mkDerivation rec {
  pname = "illogical-impulse-microtex";
  version = "r494.0e3707f";

  src = fetchFromGitHub {
    owner = "NanoMichael";
    repo = "MicroTeX";
    rev = "0e3707f6dafebb121d98b53c64364d16fefe481d";
    hash = "sha256-U6zqh+VqoLtlE0IwgfwjY9zt8e5/2R3cqf5fWXwoIi0=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    tinyxml-2
    gtkmm3
    gtksourceviewmm4
    cairomm
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-warn 'gtksourceviewmm-3.0' 'gtksourceviewmm-4.0' \
      --replace-warn 'tinyxml2.so.10' 'tinyxml2.so.11'
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt/MicroTeX
    install -Dm0755 LaTeX $out/opt/MicroTeX/LaTeX
    cp -r res $out/opt/MicroTeX/
    install -Dm0644 ../LICENSE $out/share/licenses/${pname}/LICENSE

    runHook postInstall
  '';

  meta = with lib; {
    description = "MicroTeX for illogical-impulse dotfiles";
    homepage = "https://github.com/NanoMichael/MicroTeX";
    license = licenses.mit;
    platforms = platforms.linux;
    mainProgram = "LaTeX";
  };
}
