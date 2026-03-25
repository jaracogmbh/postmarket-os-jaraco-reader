#!/bin/sh
set -e

desktop_id="io.jaraco.Reader.desktop"

xdg-mime default "$desktop_id" application/epub+zip text/markdown text/x-markdown

if command -v update-desktop-database >/dev/null 2>&1; then
  update-desktop-database >/dev/null 2>&1 || true
fi

printf 'Set %s as default for .epub and .md files.\n' "$desktop_id"
