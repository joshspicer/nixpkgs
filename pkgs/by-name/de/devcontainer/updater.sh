#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p curl jq common-updater-scripts

set -euo pipefail
pushd "$(dirname "${BASH_SOURCE[0]}")"

owner="devcontainers"
repo="cli"
version=`curl -s "https://api.github.com/repos/$owner/$repo/tags" | jq -r .[0].name | grep -oP "^v\K.*"`
url="https://raw.githubusercontent.com/$owner/$repo/v$version/"

echo $version

if [[ "$UPDATE_NIX_OLD_VERSION" == "$version" ]]; then
    echo "Already up to date!"
    exit 0
fi

rm -f package.json
wget "$url/package.json"

popd
nix-update devcontainer --version $version
