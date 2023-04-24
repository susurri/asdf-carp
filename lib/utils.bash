#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/carp-lang/Carp"
TOOL_NAME="carp"
TOOL_TEST="carp --help"

fail() {
	echo -e "asdf-$TOOL_NAME: $*"
	exit 1
}

version2d() {
	echo "$1" | awk -F. '{ printf("%d%03d%03d\n"), $1, $2, $3}'
}

curl_opts=(-fsSL)

if [ -n "${GITHUB_API_TOKEN:-}" ]; then
	curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
	sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
		LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
	git ls-remote --tags --refs "$GH_REPO" |
		grep -o 'refs/tags/v[0-9.]*' | cut -d/ -f3- | sort -u |
		sed 's/^v//'
}

list_all_versions() {
	list_github_tags
}

platform() {
	case "$OSTYPE" in
	darwin*) echo "macos" ;;
	linux*) echo "linux" ;;
	*) fail "Unsupported platform" ;;
	esac
}

arch() {
	case "$(uname -m)" in
	x86_64 | amd64) echo -n "x86_64" ;;
	*) fail "Unsupported architecture" ;;
	esac
}

download_release() {
	local version filename url platform
	version="$1"
	filename="$2"
	platform=$(platform)

	if [ "$(version2d "${version}")" -ge "$(version2d "0.5.3")" ]; then
		url="$GH_REPO/releases/download/v${version}/carp-v${version}-$(arch)-${platform}.zip"
	else
		case "$platform" in
		linux) platform="Linux" ;;
		macos) platform="macOS" ;;
		esac
		url="$GH_REPO/releases/download/v${version}_${platform}/v${version}.zip"
	fi

	echo "* Downloading $TOOL_NAME release $version..."
	curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
	local install_type="$1"
	local version="$2"
	local install_path="$3"

	if [ "$install_type" != "version" ]; then
		fail "asdf-$TOOL_NAME supports release installs only"
	fi

	(
		mkdir -p "$install_path"
		cp -r "$ASDF_DOWNLOAD_PATH"/*/* "$install_path"

		local tool_cmd
		tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
		test -x "$install_path/bin/$tool_cmd" || fail "Expected $install_path/bin/$tool_cmd to be executable."

		echo "$TOOL_NAME $version installation was successful!"
	) || (
		rm -rf "$install_path"
		fail "An error occurred while installing $TOOL_NAME $version."
	)
}
