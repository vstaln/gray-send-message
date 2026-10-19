#!/bin/sh
here="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
sys="$(uname -s)"
case "$sys" in
MINGW* | MSYS* | CYGWIN*) rel="x86_64-pc-windows-msvc/gray-send-message.exe" ;;
Darwin*)
    case "$(uname -m)" in
    arm64) rel="aarch64-apple-darwin/gray-send-message" ;;
    *) rel="x86_64-apple-darwin/gray-send-message" ;;
    esac ;;
*)
    case "$(uname -m)" in
    aarch64 | arm64) rel="aarch64-unknown-linux-musl/gray-send-message" ;;
    *) rel="x86_64-unknown-linux-musl/gray-send-message" ;;
    esac ;;
esac
if [ -x "$here/$rel" ]; then exec "$here/$rel" "$@"; fi
for cand in "$here/target/release/gray-send-message.exe" "$here/target/release/gray-send-message" "$here/target/debug/gray-send-message.exe" "$here/target/debug/gray-send-message"; do
    if [ -x "$cand" ]; then exec "$cand" "$@"; fi
done
echo "gray-send-message binary not found in $here" >&2
exit 1
