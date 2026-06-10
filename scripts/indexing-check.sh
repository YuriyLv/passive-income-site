#!/usr/bin/env bash
set -euo pipefail

# Примітки:
# - Блокуючі умови:
#   * Відсутній файл ключа (`GSC_KEY_PATH`) або змінні `GSC_SITE_URL`/`GSC_API_KEY`
#     -> перевірка Google пропускається з записом PENDING_ACCESS у протокол.
#   * Відсутній `BING_WEBMASTER_API_KEY`
#     -> перевірка Bing пропускається з записом PENDING_ACCESS у протокол.
# - Після надання доступу додати ключі у `.env` та перезапустити скрипт.
# - Файл журналу: `docs/indexing-protocol.md`

SITE_URL="${GSC_SITE_URL:-https://biztoolinsight.com.ua/}"
BING_SITE_URL="${BING_SITE_URL:-https://biztoolinsight.com.ua/}"
INDEXING_PROTOCOL="docs/indexing-protocol.md"
DATE="$(date +%F)"

check_readiness() {
  local tool="$1"
  local ok=0
  case "$tool" in
    google)
      if [[ -n "${GSC_KEY_PATH:-}" ]] && [[ -f "$GSC_KEY_PATH" ]]; then
        ok=1
      else
        ok=0
      fi
      ;;
    bing)
      if [[ -n "${BING_WEBMASTER_API_KEY:-}" ]]; then
        ok=1
      else
        ok=0
      fi
      ;;
    *)
      ok=0
      ;;
  esac
  echo "$ok"
}

run_google_check() {
  if [[ "$(check_readiness google)" -ne 1 ]]; then
    return 1
  fi

  if [[ -n "${GSC_API_KEY:-}" ]]; then
    echo "[PLACEHOLDER] Google check with API key for $SITE_URL"
    return 0
  fi

  echo "[PLACEHOLDER] Google check for $SITE_URL using service account/$GSC_KEY_PATH"
  return 0
}

run_bing_check() {
  if [[ "$(check_readiness bing)" -ne 1 ]]; then
    return 1
  fi

  echo "[PLACEHOLDER] Bing check for $BING_SITE_URL"
  return 0
}

appendix_to_protocol() {
  local system="$1"
  local status="$2"
  local coverage="$3"
  local problems="$4"
  local actions="$5"

  if ! grep -Fq "| $DATE | $system |" "$INDEXING_PROTOCOL"; then
    local row
    row="| $DATE | $system | $status | $coverage | $problems | $actions |"
    if grep -Fq "## Журнал планових перевірок" "$INDEXING_PROTOCOL"; then
      tmpfile="$(mktemp)"
      awk -v r="$row" 'index($0,"## Журнал планових перевірок"){print; print r; next}1' "$INDEXING_PROTOCOL" > "$tmpfile" && mv "$tmpfile" "$INDEXING_PROTOCOL"
    fi
  fi
}

main() {
  echo "[$(date -Iseconds)] indexing-check.sh start" >&2

  if [[ "$(check_readiness google)" -ne 1 ]]; then
    echo "[SKIP] Google: немає доступу до Search Console"
    appendix_to_protocol "Google" "пропущено" "PENDING_ACCESS" "відсутній API-доступ: немає ключа/прав у Search Console" "очікується надання доступу"
  else
    if run_google_check; then
      echo "[DONE] Google check completed"
      appendix_to_protocol "Google" "виконано" "TODO: записати з API-відповіді" "TODO: записати з API-відповіді" "TODO: записати з API-відповіді"
    fi
  fi

  if [[ "$(check_readiness bing)" -ne 1 ]]; then
    echo "[SKIP] Bing: немає доступу до Bing Webmaster"
    appendix_to_protocol "Bing" "пропущено" "PENDING_ACCESS" "відсутній API-ключ Bing Webmaster" "очікується надання доступу"
  else
    if run_bing_check; then
      echo "[DONE] Bing check completed"
      appendix_to_protocol "Bing" "виконано" "TODO: записати з API-відповіді" "TODO: записати з API-відповіді" "TODO: записати з API-відповіді"
    fi
  fi

  echo "[$(date -Iseconds)] indexing-check.sh end" >&2
}

main "$@"
