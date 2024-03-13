{ lib
, stdenv
, fetchFromSourcehut
, fetchpatch
, pkg-config
, meson
, ninja
, cairo
, pango
, wayland
, wayland-protocols
, libxkbcommon
, scdoc
}:

stdenv.mkDerivation rec {
  pname = "wmenu";
  version = "0.1.7";

  strictDeps = true;

  src = fetchFromSourcehut {
    owner = "~adnano";
    repo = "wmenu";
    rev = version;
    hash = "sha256-9do7zL7yaZuqVjastySwjsByo5ja+KUP3590VjIyVnI=";
  };

  nativeBuildInputs = [ pkg-config meson ninja ];
  buildInputs = [ cairo pango wayland libxkbcommon wayland-protocols scdoc ];

  meta = with lib; {
    description = "An efficient dynamic menu for Sway and wlroots based Wayland compositors";
    homepage = "https://git.sr.ht/~adnano/wmenu";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ eken ];
    mainProgram = "wmenu";
  };
}

