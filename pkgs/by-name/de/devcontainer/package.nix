{ lib
, mkYarnPackage
, fetchFromGitHub
, fetchYarnDeps
, nodejs_18
}:

let
  nodejs = nodejs_18;
in
mkYarnPackage rec {
  pname = "devcontainers";
  version = "0.55.0";

  src = fetchFromGitHub {
    owner = "devcontainers";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-NrN9q8pa9MQWea1MOyQYZMudf1byEX44rgYqiK8qYnQ=";
  };

  yarnLock = "${src}/yarn.lock";
  packageJSON = ./package.json;

  offlineCache = fetchYarnDeps {
    inherit yarnLock;
    hash = "sha256-puKgUp24IdbAKaBayFxVgIiS4vZHSMVjC+WdUS7yvbs=";
  };

  nativeBuildInputs = [ nodejs.pkgs.node-pre-gyp nodejs.pkgs.node-gyp-build ];

  buildPhase = ''
    runHook preBuild

    yarn --offline compile-prod

    runHook postBuild
  '';

    passthru.updateScript = ./updater.sh;

    meta = with lib; {
        description = "Development container reference implementation";
        homepage = "https://containers.dev";
        license = licenses.mit;
        maintainers = with maintainers; [ joshspicer ];
        changelog = "${src}/CHANGELOG.md";
    };
}
