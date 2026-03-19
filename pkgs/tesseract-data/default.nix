{ lib, fetchFromGitHub, runCommand, symlinkJoin }:

let
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "tesseract-ocr";
    repo = "tessdata";
    rev = version;
    hash = "sha256-70bp4prs1zUbSzQmcqd7v736cyYWv8oNNbmZXypik5I=";
  };

  langs = [
    "afr" "amh" "ara" "asm" "aze" "aze_cyrl" "bel" "ben" "bod" "bos" "bre"
    "bul" "cat" "ceb" "ces" "chi_sim" "chi_sim_vert" "chi_tra" "chi_tra_vert"
    "chr" "cos" "cym" "dan" "dan_frak" "deu" "deu_frak" "div" "dzo" "ell"
    "eng" "enm" "epo" "equ" "est" "eus" "fao" "fas" "fil" "fin" "fra" "frk"
    "frm" "fry" "gla" "gle" "glg" "grc" "guj" "hat" "heb" "hin" "hrv" "hun"
    "hye" "iku" "ind" "isl" "ita" "ita_old" "jav" "jpn" "jpn_vert" "kan" "kat"
    "kat_old" "kaz" "khm" "kir" "kmr" "kor" "kor_vert" "lao" "lat" "lav" "lit"
    "ltz" "mal" "mar" "mkd" "mlt" "mon" "mri" "msa" "mya" "nep" "nld" "nor"
    "oci" "ori" "osd" "pan" "pol" "por" "pus" "que" "ron" "rus" "san" "sin"
    "slk" "slk_frak" "slv" "snd" "spa" "spa_old" "sqi" "srp" "srp_latn" "sun"
    "swa" "swe" "syr" "tam" "tat" "tel" "tgk" "tgl" "tha" "tir" "ton" "tur"
    "uig" "ukr" "urd" "uzb" "uzb_cyrl" "vie" "yid" "yor"
  ];

  mkLang = lang: runCommand "tesseract-data-${lang}-${version}" {
    meta = with lib; {
      description = "Tesseract OCR data (${lang})";
      homepage = "https://github.com/tesseract-ocr/tessdata";
      license = licenses.asl20;
      platforms = platforms.all;
    };
  } ''
    mkdir -p $out/share/tessdata
    install -Dm0644 ${src}/${lang}.* $out/share/tessdata/
  '';

   langPackages = lib.genAttrs langs mkLang;

in

langPackages // { 
  all = symlinkJoin {
    name = "tesseract-data-all";
    paths = builtins.attrValues langPackages;
    meta = with lib; {
      description = "Tesseract OCR data (all languages combined)";
      homepage = "https://github.com/tesseract-ocr/tessdata";
      license = licenses.asl20;
      platforms = platforms.all;
    };
  };
}
