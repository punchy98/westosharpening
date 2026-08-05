#!/bin/sh

set -eu

: "${NODE_VERSION:?NODE_VERSION must be set by the GitLab pipeline}"

required_node_version="v${NODE_VERSION}"

if command -v node >/dev/null 2>&1 \
  && command -v npm >/dev/null 2>&1 \
  && [ "$(node --version)" = "$required_node_version" ]; then
  return 0 2>/dev/null || exit 0
fi

if [ "$(uname -s)" != "Linux" ]; then
  echo "Node.js bootstrap supports Linux runners only." >&2
  exit 1
fi

case "$(uname -m)" in
  x86_64 | amd64)
    node_arch="x64"
    ;;
  aarch64 | arm64)
    node_arch="arm64"
    ;;
  *)
    echo "Unsupported runner architecture: $(uname -m)" >&2
    exit 1
    ;;
esac

project_dir="${CI_PROJECT_DIR:-$(pwd)}"
tools_dir="${project_dir}/.tools"
node_dir="${tools_dir}/node-v${NODE_VERSION}-linux-${node_arch}"
node_bin_dir="${node_dir}/bin"
archive="node-v${NODE_VERSION}-linux-${node_arch}.tar.gz"
download_dir="${tools_dir}/downloads"
archive_path="${download_dir}/${archive}"
checksums_path="${download_dir}/SHASUMS256-v${NODE_VERSION}.txt"
release_url="https://nodejs.org/dist/v${NODE_VERSION}"

download_file() {
  source_url="$1"
  destination="$2"

  if command -v curl >/dev/null 2>&1; then
    curl --fail --location --retry 3 --silent --show-error \
      --output "$destination" "$source_url"
  elif command -v wget >/dev/null 2>&1; then
    wget --https-only --tries=3 --quiet \
      --output-document="$destination" "$source_url"
  elif command -v python3 >/dev/null 2>&1; then
    python3 - "$source_url" "$destination" <<'PYTHON'
import pathlib
import sys
import urllib.request

source_url, destination = sys.argv[1:]
with urllib.request.urlopen(source_url, timeout=60) as response:
    pathlib.Path(destination).write_bytes(response.read())
PYTHON
  else
    echo "Node.js installation requires curl, wget, or Python 3." >&2
    exit 1
  fi
}

if [ ! -x "${node_bin_dir}/node" ]; then
  mkdir -p "$download_dir"

  if [ ! -f "$archive_path" ]; then
    download_file "${release_url}/${archive}" "$archive_path"
  fi

  download_file "${release_url}/SHASUMS256.txt" "$checksums_path"

  expected_checksum_line="$(grep "  ${archive}$" "$checksums_path" || true)"
  if [ -z "$expected_checksum_line" ]; then
    echo "Node.js checksum entry was not found for ${archive}." >&2
    exit 1
  fi

  printf '%s\n' "$expected_checksum_line" \
    | (cd "$download_dir" && sha256sum --check --status -)

  staging_dir="${node_dir}.staging-${CI_JOB_ID:-$$}"
  mkdir -p "$staging_dir"
  tar -xzf "$archive_path" --directory "$staging_dir" --strip-components=1

  if [ -e "$node_dir" ]; then
    echo "Cached Node.js directory is incomplete; clear the .tools CI cache and retry." >&2
    exit 1
  fi

  mv "$staging_dir" "$node_dir"
fi

export PATH="${node_bin_dir}:${PATH}"

if [ "$(node --version)" != "$required_node_version" ]; then
  echo "Expected Node.js ${required_node_version}, found $(node --version)." >&2
  exit 1
fi

if ! command -v npm >/dev/null 2>&1; then
  echo "npm was not installed with Node.js ${required_node_version}." >&2
  exit 1
fi
