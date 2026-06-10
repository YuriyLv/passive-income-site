# Social registration: browser setup workarounds

Оновлення: 2026-06-08.

**Purpose**
Give the team a minimal, executable path to unblock social account creation when a full browser UI is unavailable.

## Options

### 1. Browser Use (приоритетний)
- Install: `pip install browser-use`
- Run in headed mode with a VNC/remote desktop session if needed.
- Use existing `docs/social-account-create-runbook.md` field-by-field.
- Pros: human-like navigation, easier CAPTCHA handling.
- Cons: heavier runtime.

### 2. Playwright + saved state
- Install: `pip install playwright && playwright install chromium`
- Use `browser.new_page()` with `storage_state` to reuse any earlier session.
- Prefer Chrome-like environment; disable headless if CAPTCHA appears.
- Pros: fast, scriptable, stable selectors.
- Cons: some platforms block headless sessions aggressively.

### 3. Chromium + xvfb (fallback)
- `apt-get install -y chromium-browser xvfb`
- Use `playwright` or `puppeteer` with `--no-sandbox` and `--disable-gpu`.
- Run under `xvfb-run` if DISPLAY is missing.
- Pros: bypasses many headless detectors.
- Cons: slower and heavier.

### 4. Manual browser + reuse login cookies
- Export cookies after manual login.
- Load into Playwright/Puppeteer via `addCookies([...])`.
- Pros: no need to automate initial MFA/login.
- Cons: cookies expire.

## Decision
Start with Browser Use for X/LinkedIn/YouTube. Use Playwright for Pinterest/TikTok. Persist `storage_state` after each successful login.

## Blocker log
- Without at least one of the above flows active, social registration must remain `PENDING_BROWSER_ACCESS`.
- After activating, update `docs/social-profiles.md` and rerun `docs/social-account-create-runbook.md` steps.
