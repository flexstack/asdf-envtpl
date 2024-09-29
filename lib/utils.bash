#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/flexstack/envtpl"
TOOL_NAME="envtpl"
TOOL_TEST="envtpl --version"
platform=$(uname -ms)

fail() {
	echo -e "asdf-$TOOL_NAME: $*"
	exit 1
}

curl_opts=(-fsSL)

# NOTE: You might want to remove this if envtpl is not hosted on GitHub releases.
if [ -n "${GITHUB_API_TOKEN:-}" ]; then
	curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
	sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
		LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
	git ls-remote --tags --refs "$GH_REPO" |
		grep -o 'refs/tags/.*' | cut -d/ -f3- |
		sed 's/^v//' # NOTE: You might want to adapt this sed to remove non-version strings from tags
}

list_all_versions() {
	list_github_tags
}

download_release() {
	local version filename url
	version="$1"
	filename="$2"

	case $platform in
	'Darwin x86_64')
			target=darwin-x86_64
			;;
	'Darwin arm64')
			target=darwin-arm64
			;;
	'Linux aarch64' | 'Linux arm64')
			target=linux-arm64
			;;
	'MINGW64'*)
			target=windows-x86_64
			;;
	'Linux x86_64' | *)
			target=linux-x86_64
			;;
	esac

	if [[ $target = darwin-x86_64 ]]; then
			# Is this process running in Rosetta?
			# redirect stderr to devnull to avoid error message when not running in Rosetta
			if [[ $(sysctl -n sysctl.proc_translated 2>/dev/null) = 1 ]]; then
					target=darwin-arm64
			fi
	fi
	
	exe_name=envtpl
	ext_name=.tar.gz
	if [[ $target = windows-x86_64 ]]; then
			exe_name=$exe_name.exe
			ext_name=.zip
	fi

	url="$GH_REPO/releases/download/v$version/envtpl-$target$ext_name"

	echo "* Downloading $TOOL_NAME release $version..."
	echo "  $url"
	echo "  $filename"
	curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
	local install_type="$1"
	local version="$2"
	local install_path="${3%/bin}/bin"

	if [ "$install_type" != "version" ]; then
		fail "asdf-$TOOL_NAME supports release installs only"
	fi

	(
		mkdir -p "$install_path"
		cp -r "$ASDF_DOWNLOAD_PATH"/* "$install_path"

		local tool_cmd
		tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
		test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

		echo "$TOOL_NAME $version installation was successful!"
	) || (
		rm -rf "$install_path"
		fail "An error occurred while installing $TOOL_NAME $version."
	)
}
