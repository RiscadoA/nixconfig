{ lib, buildNpmPackage, fetchurl, nodejs_22 }:

buildNpmPackage rec {
  pname = "openchamber";
  version = "1.9.8";

  src = fetchurl {
    url = "https://github.com/openchamber/openchamber/releases/download/v${version}/openchamber-web-${version}.tgz";
    hash = "sha256-zAcxXmj22lYZQvZaoXpIWz/1kalM8uKnfRHVv7ZMMu4=";
  };

  sourceRoot = "package";
  npmDepsHash = "sha256-fSAypMA/jCesN+CbbKIxK0b/LWJYwdGD0CPUJIEhhaY=";

  nodejs = nodejs_22;
  dontNpmBuild = true;

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  meta = with lib; {
    description = "Desktop and web interface for OpenCode AI agent";
    homepage = "https://openchamber.dev/";
    changelog = "https://github.com/openchamber/openchamber/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "openchamber";
    platforms = platforms.linux;
  };
}
