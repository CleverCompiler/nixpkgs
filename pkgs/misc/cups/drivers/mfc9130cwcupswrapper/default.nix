{ lib
, stdenv
, fetchurl
, dpkg
, makeWrapper
, coreutils
, gnugrep
, gnused
, mfc9130cwlpr
, pkgsi686Linux
, psutils
}:

stdenv.mkDerivation rec {
  pname = "mfc9130cwcupswrapper";
  version = "1.1.4-0";

  src = fetchurl {
          #https://download.brother.com/welcome/dlf100412/mfc9130cwcupswrapper-1.1.4-0.i386.deb
    url = "https://download.brother.com/welcome/dlf100412/${pname}-${version}.i386.deb";
    sha256 = "4ecd12444e0eec9e9e0d15a1c37917b89a118f8e6e3685e83d8bbfe7b4bc92c1";
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
    lpr=${mfc9130cwlpr}/opt/brother/Printers/mfc9130cw
    dir=$out/opt/brother/Printers/mfc9130cw

    interpreter=${pkgsi686Linux.glibc.out}/lib/ld-linux.so.2
    patchelf --set-interpreter "$interpreter" "$dir/cupswrapper/brcupsconfpt1"

    substituteInPlace $dir/cupswrapper/cupswrappermfc9130cw \
      --replace "mkdir -p /usr" ": # mkdir -p /usr" \
      --replace '/opt/brother/''${device_model}/''${printer_model}/lpd/filter''${printer_model}' "$lpr/lpd/filtermfc9130cw" \
      --replace '/usr/share/ppd/Brother/brother_''${printer_model}_printer_en.ppd' "$dir/cupswrapper/brother_mfc9130cw_printer_en.ppd" \
      --replace '/usr/share/cups/model/Brother/brother_''${printer_model}_printer_en.ppd' "$dir/cupswrapper/brother_mfc9130cw_printer_en.ppd" \
      --replace '/opt/brother/Printers/''${printer_model}/' "$lpr/" \
      --replace 'nup="psnup' "nup=\"${psutils}/bin/psnup" \
      --replace '/usr/bin/psnup' "${psutils}/bin/psnup"

    mkdir -p $out/lib/cups/filter
    mkdir -p $out/share/cups/model

    ln $dir/cupswrapper/cupswrappermfc9130cw $out/lib/cups/filter
    ln $dir/cupswrapper/brother_mfc9130cw_printer_en.ppd $out/share/cups/model

    sed -n '/!ENDOFWFILTER!/,/!ENDOFWFILTER!/p' "$dir/cupswrapper/cupswrappermfc9130cw" | sed '1 br; b; :r s/.*/printer_model=mfc9130cw; cat <<!ENDOFWFILTER!/'  | bash > $out/lib/cups/filter/brother_lpdwrapper_mfc9130cw
    sed -i "/#! \/bin\/sh/a PATH=${lib.makeBinPath [ coreutils gnused gnugrep ]}:\$PATH" $out/lib/cups/filter/brother_lpdwrapper_mfc9130cw
    chmod +x $out/lib/cups/filter/brother_lpdwrapper_mfc9130cw
    '';

  meta = with lib; {
    description = "Brother MFC-9130CW CUPS wrapper driver";
    homepage = "http://www.brother.com/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ hexa ];
  };
}
