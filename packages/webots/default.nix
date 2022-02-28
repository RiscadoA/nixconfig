{ stdenv, lib, fetchurl, dpkg, dbus, freetype, gcc, gd, libGLU, gtk3, libssh,
  xorg, autoPatchelfHook, libsForQt5, libxslt, libzip, gnumake, nss, glib,
  zziplib, atk, freeimage, alsaLib, steam-run, bash }:

#with import <nixpkgs> {};
 
stdenv.mkDerivation rec {
  name = "webots";
  version = "R2021b";

  src = fetchurl {
    url = "https://github.com/cyberbotics/webots/releases/download/R2021b/webots_2021b_amd64.deb";
    sha512 = "e7e04c872a171f542f960a77a53dd35ebe87a3b1bb5bfe1fc2e3f9b8dcb6c870161d2925c0bee9ca3e2cb38eafb9fd8107380fd23c7321ce63162515592d04a9";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    dbus
    freetype
    gcc
    gd
    libGLU
    gtk3
    libssh
    xorg.libX11
    xorg.libXaw
    xorg.libXrandr
    xorg.libXrender
    xorg.libXtst
    xorg.libXdamage
    xorg.xorgserver
    libxslt
    libzip
    gnumake
    nss
    glib
    zziplib
    atk
    freeimage
    alsaLib
  ];

  autoPatchelfIgnoreMissingDeps = true;
  dontUnpack = true;
  dontBuild = true;
  dontStrip = true;

  installPhase = ''
    mkdir -p $out
    dpkg -x $src $out
    mv $out/usr/* $out
    rmdir $out/usr
    rm $out/local/bin/webots
    rmdir $out/local/bin
    mkdir $out/bin
    echo "#!${bash}/bin/bash" > $out/bin/webots
    echo "${steam-run}/bin/steam-run $out/local/webots/webots" >> $out/bin/webots
    chmod 555 $out/bin/webots
  '';
  
  meta = {
    description = "desktop app for webots";
    homepage = "https://cyberbotics.com/";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
  };
}
