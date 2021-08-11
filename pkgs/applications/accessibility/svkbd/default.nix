{ lib
, stdenv
, fetchurl
, writeText
, pkg-config
, libX11
, libXft
, libXi
, libXinerama
, libXtst
, layout ? null
, conf ? null
, patches ? [ ]
}:

stdenv.mkDerivation rec {
  pname = "svkbd";
  version = "0.4";

  src = fetchurl {
    url = "https://dl.suckless.org/tools/svkbd-${version}.tar.gz";
    sha256 = "sha256-j9RW5/4cb8l3FK9jpFf206l1rQhCR5H/WMiu7I6rzV8=";
  };

  inherit patches;

  postPatch = let
    configFile = if lib.isDerivation conf || lib.isPath conf then
      conf
    else
      writeText "config.def.h" conf;
  in lib.optionalString (conf != null) ''
    cp ${configFile} config.def.h
  '';

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libX11
    libXft
    libXi
    libXinerama
    libXtst
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ] ++ lib.optional (layout != null) "LAYOUT=${layout}";

  meta = with lib; {
    description = "Simple virtual keyboard";
    homepage = "https://tools.suckless.org/x/svkbd/";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ dotlambda ];
  };
}
