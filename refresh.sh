#!/bin/sh
# Rebuild the dashboard in the private repo and copy the published files here.
set -e
SRC="$HOME/Documents/GitHub/NFL_AI_private"
DEST="$(cd "$(dirname "$0")" && pwd)"
"$SRC/private/.venv/bin/python" "$SRC/public/dashboard/dashboard.py"
cp "$SRC/public/dashboard/dashboard.html" "$DEST/index.html"
cp -R "$SRC/public/dashboard/teampng/." "$DEST/teampng/"
echo "copied to $DEST — review, then commit and push"
