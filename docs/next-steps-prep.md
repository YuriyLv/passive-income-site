# Next-steps prep

Цей файл фіксує підготовчі дії, які можна виконати без доступу до зовнішніх сервісів.

## 1. Підготовка `.env` до заповнення

- Додати у `.env` змінні:
  - `GSC_SITE_URL=https://biztoolinsight.com.ua/`
  - `GSC_KEY_PATH=<шлях до JSON-ключа сервісного облікового запису>`
  - `BING_SITE_URL=https://biztoolinsight.com.ua/`
  - `BING_WEBMASTER_API_KEY=<API-ключ Bing Webmaster>`
- Після надання доступу заповнити реальними значеннями та перезапустити `bash scripts/indexing-check.sh`.

## 2. Перевірка партнерських порталів

- Підготувати перелік URL партнерських порталів, до яких потрібен доступ: `docs/partner-profiles/partner-profile-population-plan.md`.
- Доступ очікується через Browser Use; після активації виконати реєстрацію/вхід.

## 3. Реєстрація соцмереж

- Перевірити `docs/social-account-create-runbook.md` та `docs/social-browser-setup-workarounds.md`.
- Після активації браузера виконати планову реєстрацію профілів та зберегти логін/URL у `docs/social-profiles.md`.
