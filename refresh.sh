#!/bin/sh
# Refresh the published dashboard from the private model repo.
#
#   ./refresh.sh          rebuild and copy here, leave the commit to you
#   ./refresh.sh --push   also commit and push, which publishes immediately
#
# The rebuild reads whatever odds are already on disk; it does not call
# TheOddsAPI and costs no credits. To pull fresh prices first, run
# public/collect_book/snap.sh dense in the private repo - that collector
# rebuilds dashboard.html itself when it finishes.
set -eu

SRC="${NFL_AI_PRIVATE:-$HOME/Documents/GitHub/NFL_AI_private}"
DEST="$(cd "$(dirname "$0")" && pwd)"
PY="$SRC/private/.venv/bin/python"

[ -x "$PY" ] || { echo "no interpreter at $PY - set NFL_AI_PRIVATE to the private repo" >&2; exit 1; }

"$PY" "$SRC/public/dashboard/dashboard.py"
cp "$SRC/public/dashboard/dashboard.html" "$DEST/index.html"
cp -R "$SRC/public/dashboard/teampng/." "$DEST/teampng/"

# The board is overwritten every run, so its history is not a record of what was
# posted. The week's slip is small, diffable and timestamped by its commit -
# that is the part worth keeping. Only the social columns go over: no model
# probabilities, EV or stake sizing.
PICKS="$SRC/public/prop_model_A_v0.1/outputs"
if [ -f "$PICKS/picks_social.csv" ] && [ -f "$PICKS/picks.csv" ]; then
  SLUG="$(awk -F, 'NR==2 {split($1, g, "_"); printf "%s-w%s", g[1], g[2]}' "$PICKS/picks.csv")"
  if [ -n "$SLUG" ]; then
    mkdir -p "$DEST/picks"
    cp "$PICKS/picks_social.csv" "$DEST/picks/$SLUG.csv"
    echo "slip:  picks/$SLUG.csv"
  fi
fi

echo "board: index.html ($(wc -c < "$DEST/index.html" | tr -d ' ') bytes)"

if [ "${1:-}" = "--push" ]; then
  cd "$DEST"
  git add -A
  git commit -m "Refresh board $(date '+%Y-%m-%d %H:%M')" || { echo "nothing changed"; exit 0; }
  git push
  echo "pushed - live in about a minute at https://johanntin.github.io/NFL/"
else
  echo "review, then: git add -A && git commit -m 'Refresh board' && git push"
fi
