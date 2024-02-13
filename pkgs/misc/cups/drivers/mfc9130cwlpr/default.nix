{ stdenv
, lib
, fetchurl
, dpkg
, makeWrapper
, coreutils
, file
, gawk
, ghostscript
, gnused
, pkgsi686Linux
}:


stdenv.mkDerivation rec {
  pname = "mfc9130cwlpr";
  version = "1.1.2-1";

  src = fetchurl {
          #https://download.brother.com/welcome/dlf100410/mfc9130cwlpr-1.1.2-1.i386.deb
    url = "https://download.brother.com/welcome/dlf100410/${pname}-${version}.i386.deb";
    sha256 = "6ea12c777fd19735767757e977591d8c51353ccda7b8e4af130cc48aee85736d";
  };

  unpackPhase = ''
    dpkg-deb -x $src $out
  '';

  nativeBuildInputs = [
    dpkg
    makeWrapper
  ];

  dontBuild = true;

  installPhase = ''
    dir=$out/opt/brother/Printers/mfc9130cw

    patchelf --set-interpreter ${pkgsi686Linux.glibc.out}/lib/ld-linux.so.2 $dir/lpd/brmfc9130cdnfilter

    wrapProgram $dir/inf/setupPrintcapij \
      --prefix PATH : ${lib.makeBinPath [
        coreutils
      ]}

    substituteInPlace $dir/lpd/filtermfc9130cw \
      --replace "BR_CFG_PATH=" "BR_CFG_PATH=\"$dir/\" #" \
      --replace "BR_LPD_PATH=" "BR_LPD_PATH=\"$dir/\" #"

    wrapProgram $dir/lpd/filtermfc9130cw \
      --prefix PATH : ${lib.makeBinPath [
        coreutils
        file
        ghostscript
        gnused
      ]}

    substituteInPlace $dir/lpd/psconvertij2 \
      --replace '`which gs`' "${ghostscript}/bin/gs"

    wrapProgram $dir/lpd/psconvertij2 \
      --prefix PATH : ${lib.makeBinPath [
        gnused
        gawk
      ]}
  '';

  meta = with lib; {
    description = "Brother MFC-9130CW LPR printer driver";
    homepage = "http://www.brother.com/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ hexa ];
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
