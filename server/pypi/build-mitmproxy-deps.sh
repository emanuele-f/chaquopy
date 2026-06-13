#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

PYTHON=3.13
ABIS=(arm64-v8a x86_64)
RUST_TARGETS=(aarch64-linux-android x86_64-linux-android)
PACKAGES=(aioquic pylsqpack msgpack mitmproxy_rs bcrypt zstandard)

if ! command -v rustup >/dev/null; then
    echo "rustup is not installed or not on PATH" >&2
    exit 1
fi

installed=$(rustup target list --installed)
for target in "${RUST_TARGETS[@]}"; do
    if ! grep -qx "$target" <<<"$installed"; then
        echo "Rust target $target is missing, install it with: rustup target add $target" >&2
        exit 1
    fi
done

for abi in "${ABIS[@]}"; do
    for package in "${PACKAGES[@]}"; do
        echo "==> Building $package ($abi)"
        ./build-wheel.py --python "$PYTHON" --abi "$abi" "$package"
    done
done
