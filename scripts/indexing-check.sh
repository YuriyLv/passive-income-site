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

normalize_count() {
  local raw="$1"
  if [[ -z "$raw" ]]; then
    echo 'n/a'
  elif [[ "$raw" =~ ^[0-9]+$ ]]; then
    echo "$raw"
  else
    echo 'n/a'
  fi
}

append_protocol_row() {
  local system="$1"
  local status="$2"
  local coverage="$3"
  local scanned="$4"
  local errors="$5"
  local warnings="$6"
  local problems="$7"
  local actions="$8"

  if ! grep -Fq "| $DATE | $system |" "$INDEXING_PROTOCOL"; then
    local row="| $DATE | $system | $status | $coverage | $errors | $warnings | $problems | $actions |"
    if grep -Fq "## Журнал планових перевірок" "$INDEXING_PROTOCOL"; then
      local tmpfile
      tmpfile="$(mktemp)"
      awk -v r="$row" 'index($0,"## Журнал планових перевірок"){print; print r; next}1' "$INDEXING_PROTOCOL" > "$tmpfile" && mv "$tmpfile" "$INDEXING_PROTOCOL"
    fi
  fi
}

search_console_coverage() {
  local key_path="$1"
  local site_url="$2"
  local coverage_url="https://searchconsole.googleapis.com/webmasters/v3/sites/${site_url}/searchAnalytics/query"

  if ! command -v curl >/dev/null 2>&1; then
    echo '[PLACEHOLDER] Google check for ${site_url} using service account/${key_path}'
    return 0
  fi

  local token_request_body=""
  local access_token=""
  if [[ -f "$key_path" ]]; then
    if ! command -v jq >/dev/null 2>&1; then
      echo '[PLACEHOLDER] Google check for ${site_url} using service account/${key_path}'
      return 0
    fi
    local client_email client_id project_id
    client_email="$(jq -r '.client_email // empty' "$key_path")"
    client_id="$(jq -r '.client_id // empty' "$key_path")"
    project_id="$(jq -r '.project_id // empty' "$key_path")"
    if [[ -n "$client_email" && -n "$client_id" && -n "$project_id" ]]; then
      token_request_body="$(jq -n --arg email "$client_email" --arg id "$client_id" --arg project "$project_id" '{iss: $email, scope: "https://www.googleapis.com/auth/webmasters.readonly", aud: "https://oauth2.googleapis.com/token", exp: (now + 3540) | floor, iat: now | floor, sub: $email}' 2>/dev/null || true)"
    fi
  fi

  if [[ -n "${GSC_API_KEY:-}" ]]; then
    local api_key_encoded
    api_key_encoded="$(printf '%s' "$GSC_API_KEY" | sed 's/+/%2B/g;s/\//%2F/g;s/=/%3D/g')"
    local url="$coverage_url?key=$api_key_encoded"
    local http_status
    http_status="$(curl -sS -o /tmp.gsc.google.response.$$ -w '%{http_code}' -X POST "$url" -H 'Content-Type: application/json' -d '{"key":"'$api_key_encoded'","startDate":"2026-01-01","endDate":"'$(date +%F)'","dimensions":[]}' 2>/dev/null || true)"
    local count
    count="$(jq -r 'if type=="array" then tostring else (if type=="object" then (.responses // .rows // empty) else empty end)' /tmp.gsc.google.response.$$ 2>/dev/null || true)"
    rm -f /tmp.gsc.google.response.$$
  fi

  echo "[PLACEHOLDER] Google check for ${site_url} using service account/${key_path}"
  return 0
}

bing_indexed_count() {
  local api_key="$1"
  local site_url="$2"
  local url="https://ssl.bing.com/webmaster/api.svc/json/GetUrlSubmissionQuota?apikey=${api_key}&siteUrl=${site_url}"

  if ! command -v curl >/dev/null 2>&1; then
    echo "n/a"
    return 0
  fi

  local response
  if ! response="$(curl -sS "$url" 2>/dev/null)"; then
    echo "n/a"
    return 0
  fi

  local count
  count="$(printf '%s' "$response" | sed -n 's/.*[^0-9]\([0-9][0-9]*\).*/\1/p' | head -n1 2>/dev/null || true)"
  if [[ -z "$count" ]]; then
    count="$(printf '%s' "$response" | sed -n 's/.*"Quota":[ ]*\([0-9][0-9]*\).*/\1/p' | head -n1 2>/dev/null || true)"
  fi
  if [[ -z "$count" ]]; then
    count="$(printf '%s' "$response" | sed -n 's/.*"Count":[ ]*\([0-9][0-9]*\).*/\1/p' | head -n1 2>/dev/null || true)"
  fi
  if [[ -z "$count" ]]; then
    count="$(printf '%s' "$response" | sed -n 's/.*[^0-9]\([0-9][0-9]*\)[^0-9].*/\1/p' | head -n1 2>/dev/null || true)"
  fi
  if [[ -z "$count" ]]; then
    count="$(printf '%s' "$response" | grep -Eo '[0-9]{1,9}' | head -n1 2>/dev/null || true)"
  fi
  if [[ -z "$count" ]]; then
    echo "n/a"
    return 0
  fi
  echo "$count"
}

run_google_check() {
  local key_path="${GSC_KEY_PATH:-}"
  if [[ -z "$key_path" ]] || [[ ! -f "$key_path" ]]; then
    return 1
  fi

  # Запасний варіант: спроба прямого виклику через curl, інший шлях залишаємось
  local coverage="n/a"
  local error_count="n/a"
  local warning_count="n/a"
  if command -v curl >/dev/null 2>&1; then
    local site_encoded
    site_encoded="$(printf '%s' "$SITE_URL" | sed 's/:/%3A/g; s/\//%2F/g')"
    local url="https://searchconsole.googleapis.com/webmasters/v3/sites/${site_encoded}/urlInspection/index/inspect"
    local response='/tmp.biztoolinsight.google.$$'
    local http_code
    http_code="$(curl -sS -o "$response" -w '%{http_code}' -X POST "$url" \
      -H 'Content-Type: application/json' \
      -d '{"inspectionUrl":"'$SITE_URL'","siteUrl":"'$SITE_URL'"}' 2>/dev/null || true)"
    if [[ "$http_code" =~ ^2 ]]; then
      coverage="partial"
      error_count="0"
      warning_count="0"
    else
      coverage="unreachable"
      error_count="$http_code"
      warning_count="0"
    fi
    rm -f "$response"
  else
    coverage="n/a"
    error_count="n/a"
    warning_count="n/a"
  fi

  if [[ "$coverage" == "unreachable" ]]; then
    append_protocol_row "Google" "не вдалося" "$coverage" "n/a" "$error_count" "$warning_count" \
      "неможливо виконати перевірку через код відповіді: ${error_count}" \
      "перевірте GSC_KEY_PATH/GSC_SITE_URL та виконання наступного кроку runbook"
  elif [[ "$coverage" == "partial" ]]; then
    append_protocol_row "Google" "потребує оновлення" "$coverage" "partial" "$error_count" "$warning_count" \
      "API відповів, але деталізація поки не витягнута" \
      "замінити на реальні метрики з Search Console"
  else
    append_protocol_row "Google" "потребує оновлення" "$coverage" "n/a" "$error_count" "$warning_count" \
      "потрібно інтегрувати сервісний акаунт для отримання Coverage/Scan" \
      "перевірте доступ до API та ключ GSC_KEY_PATH"
  fi
  return 0
}

run_bing_check() {
  local api_key="${BING_WEBMASTER_API_KEY:-}"
  if [[ -z "$api_key" ]]; then
    return 1
  fi

  if ! command -v curl >/dev/null 2>&1; then
    append_protocol_row "Bing" "потребує оновлення" "unreachable" "n/a" "missing_tool" "missing_tool" "curl не доступний на цьому середовищі" "встановіть curl та перезапустіть скрипт"
    return 0
  fi

  local quota_url="https://ssl.bing.com/webmaster/api.svc/json/GetUrlSubmissionQuota?apikey=${api_key}&siteUrl=${BING_SITE_URL-}"
  local submission_url="https://ssl.bing.com/webmaster/api.svc/json/SubmitUrl?apikey=${api_key}&siteUrl=${BING_SITE_URL}"
  local quota_response='/tmp.biztoolinsight.bing.$$'
  local submission_response='/tmp.biztoolinsight.bing.submit.$$'

  local http_status
  http_status="$(curl -sS -o "$quota_response" -w '%{http_code}' "$quota_url" 2>/dev/null || true)"
  local indexed_count="n/a"
  local error_count="$http_status"
  local warning_count="0"
  if [[ "$http_status" =~ ^2 ]]; then
    indexed_count="$(bing_indexed_count "$api_key" "$BING_SITE_URL")"
    error_count="0"
  else
    indexed_count="n/a"
  fi

  local problems="немає проблем"
  if [[ "$http_status" != "200" ]]; then
    problems="HTTP ${http_status} при запиті Bing Webmaster API"
  fi
  local actions="оновити ключ/bing_endpoint; або перевірити `BING_SITE_URL` у `.env`"

  rm -f "$quota_response"
  rm -f "$submission_response"

  append_protocol_row "Bing" "потребує оновлення" "$indexed_count" "$indexed_count" "$error_count" "$warning_count" "$problems" "$actions"
  return 0
}

main() {
  echo "[$(date -Iseconds)] indexing-check.sh start" >&2

  if [[ "$(check_readiness google)" -ne 1 ]]; then
    echo "[SKIP] Google: немає доступу до Search Console" >&2
    append_protocol_row "Google" "пропущено" "PENDING_ACCESS" "PENDING_ACCESS" "0" "0" "відсутній API-доступ: немає ключа/прав у Search Console" "очікується надання доступу"
  else
    if run_google_check; then
      echo "[DONE] Google check completed" >&2
    else
      echo "[FAIL] Google check failed" >&2
    fi
  fi

  if [[ "$(check_readiness bing)" -ne 1 ]]; then
    echo "[SKIP] Bing: немає доступу до Bing Webmaster" >&2
    append_protocol_row "Bing" "пропущено" "PENDING_ACCESS" "PENDING_ACCESS" "0" "0" "відсутній API-ключ Bing Webmaster" "очікується надання доступу"
  else
    if run_bing_check; then
      echo "[DONE] Bing check completed" >&2
    else
      echo "[FAIL] Bing check failed" >&2
    fi
  fi

  echo "[$(date -Iseconds)] indexing-check.sh end" >&2
}

main "$@"
