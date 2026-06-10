#!/usr/bin/env bash
set -euo pipefail
cd /home/deploy/projects/passive-income-site || exit 1
mkdir -p logs
log_file="logs/indexing-weekly-$(date +%F).log"
echo "[$(date -Iseconds)] indexing-weekly.sh start" | tee -a "$log_file"
if [[ -f scripts/indexing-check.sh ]]; then
  bash scripts/indexing-check.sh >> "$log_file" 2>&1 || true
else
  echo "[ERROR] scripts/indexing-check.sh not found" | tee -a "$log_file"
fi
echo "[$(date -Iseconds)] indexing-weekly.sh end" | tee -a "$log_file"
