#!/usr/bin/env bash
set -euo pipefail

CHROME="${CHROME_PATH:-/Applications/Google Chrome.app/Contents/MacOS/Google Chrome}"
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
INPUT="file://$PROJECT_ROOT/_site/og-image/index.html"
OUTPUT="$PROJECT_ROOT/extra/images/og-default.png"

if [[ ! -f "$PROJECT_ROOT/_site/og-image/index.html" ]]; then
  echo "Error: _site/og-image/index.html not found. Run mix tableau.build first." >&2
  exit 1
fi

mkdir -p "$(dirname "$OUTPUT")"

"$CHROME" \
  --headless=new \
  --disable-gpu \
  --no-sandbox \
  --screenshot="$OUTPUT" \
  --window-size=1200,630 \
  --hide-scrollbars \
  --force-device-scale-factor=1 \
  --run-all-compositor-stages-before-draw \
  "$INPUT" 2>/dev/null

echo "Generated OG image: $OUTPUT"
