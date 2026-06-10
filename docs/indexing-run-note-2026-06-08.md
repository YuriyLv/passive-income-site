# Run note: 2026-06-08 indexing preflight

- Formal access: not granted yet for Google Search Console or Bing Webmaster.
- Required inputs:
  - `GSC_KEY_PATH`: path to service account JSON for Google Search Console API
  - optional `GSC_API_KEY`: supplemental key if available
  - `BING_WEBMASTER_API_KEY`: API key for Bing
- Script behavior without access: records `PENDING_ACCESS` in `docs/indexing-protocol.md` and skips live checks.
- Convenience script: `scripts/indexing-check.sh` (ready; to be re-run after access is granted).
- Prompt for operator (human): provide `.env` values from `docs/02-indexing-access-request.md` checklist, then rerun script.
