#!/bin/sh
# Copies the fonts built from private-build-plans.toml into docs/ for the website. It doesn't
# compile anything: build first (see Build in README.md), then run this from anywhere.
#   docs/fonts/     the four WOFF2 files and OFL.txt
#   docs/download/  NatewaveMono-TTF-Unhinted.zip: the four unhinted TTFs and OFL.txt in NatewaveMono/
set -eu
LC_ALL=C
export LC_ALL
cd "$(dirname "$0")/.."

dist=Iosevka/dist/NatewaveMono
styles="Regular Italic Bold BoldItalic"
fail() { echo "update-site-fonts: $*" >&2; exit 1; }

[ -d "$dist" ] || fail "no build in $dist. Build webfont-unhinted::NatewaveMono first (see Build in README.md)."
cmp -s private-build-plans.toml Iosevka/private-build-plans.toml ||
  fail "Iosevka/private-build-plans.toml differs from private-build-plans.toml. Copy the plan into Iosevka/ and rebuild."
for s in $styles; do
  for f in "$dist/WOFF2-Unhinted/NatewaveMono-$s.woff2" "$dist/TTF-Unhinted/NatewaveMono-$s.ttf"; do
    [ -s "$f" ] || fail "$f is missing. Build webfont-unhinted::NatewaveMono first."
  done
done
command -v zip >/dev/null || fail "zip is required."

pkg=$(mktemp -d)
trap 'rm -rf "$pkg"' EXIT
mkdir -p docs/fonts docs/download "$pkg/NatewaveMono"
for s in $styles; do
  cp -p "$dist/WOFF2-Unhinted/NatewaveMono-$s.woff2" docs/fonts/
  cp -p "$dist/TTF-Unhinted/NatewaveMono-$s.ttf" "$pkg/NatewaveMono/"
done
cp -p Iosevka/LICENSE.md docs/fonts/OFL.txt
cp -p Iosevka/LICENSE.md "$pkg/NatewaveMono/OFL.txt"

zip=$PWD/docs/download/NatewaveMono-TTF-Unhinted.zip
rm -f "$zip"
# Same fonts, same zip: build times kept (cp -p, touch -r), extra attributes left out (-X), fixed entry order.
touch -r "$dist/TTF-Unhinted/NatewaveMono-Regular.ttf" "$pkg/NatewaveMono"
(cd "$pkg" && zip -q -X "$zip" NatewaveMono NatewaveMono/*)

ls -l docs/fonts docs/download
echo "Updated docs/fonts and docs/download. Commit them and push to publish."
