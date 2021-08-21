{ stdenv, lib, fetchFromGitHub, pkg-config, cmake, hidapi }:

stdenv.mkDerivation rec {
  name = "headsetcontrol";
  version = "2.4";

  nativeBuildInputs = [ pkg-config cmake hidapi ];

  src = fetchFromGitHub {
    owner = "Sapd";
    repo = "HeadsetControl";
    rev = version;
    sha256 = "sha256-T+606zFLRg2FvCSaHMrYlXJgR53u6SFfSq9OzfN0Dfc=";
  };

  installPhase = ''
    make install
    mkdir -p $out/etc/udev/rules.d
    $out/bin/headsetcontrol -u > $out/etc/udev/rules.d/70-headsets.rules
  '';

  meta = {
    description = "a tool to control certain aspects of usb-connected headsets on linux";
    homepage = "https://github.com/Sapd/HeadsetControl";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
  };
}
