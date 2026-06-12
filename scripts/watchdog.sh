#!/usr/bin/env bash
set -euo pipefail
PROJECT="/home/deploy/projects/passive-income-site"
cd "$PROJECT"

STATE_FILE="$PROJECT/.last_check_marker"

# Оновлюваний стан
total=$(find posts -maxdepth 1 -name '*.html' | wc -l)
unfixed=$(find posts -maxdepth 1 -name '*.html' -exec grep -l 'images.unsplash.com/photo-.*auto=formathttps://' {} + 2>/dev/null | wc -l || true)
status=$(git status --short | wc -l)

current="files=${total};unfixed=${unfixed};dirty=${status}"

# Якщо стан не змінився з попереднього запуску — мовчимо
if [ -f "$STATE_FILE" ]; then
  prev=$(cat "$STATE_FILE" | tr -d '\n')
  if [ "$current" = "$prev" ]; then
    exit 0
  fi
fi

echo "$current" > "$STATE_FILE"

if [ "$unfixed" -eq 0 ] && [ "$status" -eq 0 ]; then
  echo "OK: всі $total статей виправлено, робочий каталог чистий."
else
  echo "CHANGE: файлів=$total, невиправлених=$unfixed, змін у робочому каталозі=$status"
fi
