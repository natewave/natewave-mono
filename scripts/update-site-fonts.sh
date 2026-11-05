#!/bin/sh
# Copies the fonts built from private-build-plans.toml into docs/ for the website. It doesn't
# compile anything: build first (see Build in README.md), then run this from anywhere.
#   docs/fonts/     each family's four WOFF2 files, and OFL.txt
#   docs/download/  <Family>-TTF-Unhinted.zip: the four unhinted TTFs and OFL.txt in a <Family>/ folder
set -eu
LC_ALL=C
export LC_ALL
cd "$(dirname "$0")/.."

families="NatewaveMono NatewaveSans"
styles="Regular Italic Bold BoldItalic"
fail() { echo "update-site-fonts: $*" >&2; exit 1; }

cmp -s private-build-plans.toml Iosevka/private-build-plans.toml ||
  fail "Iosevka/private-build-plans.toml differs from private-build-plans.toml. Copy the plan into Iosevka/ and rebuild."
for fam in $families; do
  dist=Iosevka/dist/$fam
  [ -d "$dist" ] || fail "no build in $dist. Build webfont-unhinted::$fam first (see Build in README.md)."
  for s in $styles; do
    for f in "$dist/WOFF2-Unhinted/$fam-$s.woff2" "$dist/TTF-Unhinted/$fam-$s.ttf"; do
      [ -s "$f" ] || fail "$f is missing. Build webfont-unhinted::$fam first."
    done
  done
done
command -v zip >/dev/null || fail "zip is required."

pkg=$(mktemp -d)
trap 'rm -rf "$pkg"' EXIT
mkdir -p docs/fonts docs/download
cp -p Iosevka/LICENSE.md docs/fonts/OFL.txt
for fam in $families; do
  dist=Iosevka/dist/$fam
  mkdir "$pkg/$fam"
  for s in $styles; do
    cp -p "$dist/WOFF2-Unhinted/$fam-$s.woff2" docs/fonts/
    cp -p "$dist/TTF-Unhinted/$fam-$s.ttf" "$pkg/$fam/"
  done
  cp -p Iosevka/LICENSE.md "$pkg/$fam/OFL.txt"

  zip=$PWD/docs/download/$fam-TTF-Unhinted.zip
  rm -f "$zip"
  # Same fonts, same zip: build times kept (cp -p, touch -r), extra attributes left out (-X), fixed entry order.
  touch -r "$dist/TTF-Unhinted/$fam-Regular.ttf" "$pkg/$fam"
  (cd "$pkg" && zip -q -X "$zip" "$fam" "$fam"/*)
done

ls -l docs/fonts docs/download
echo "Updated docs/fonts and docs/download. Commit them and push to publish."
