# План отримання доступу для перевірок індексації

Цей документ фіксує потреби, необхідні права/доступи та порядок запиту доступу для регулярних перевірок Coverage/Scan у Google Search Console та Bing Webmaster.

## Потреба

- Щотижня перевіряти Coverage/Scan у Google Search Console та Bing Webmaster.
- Автоматизувати перевірки, щоб не виконувати їх вручну через браузер.
- Фіксувати результати у `docs/indexing-protocol.md`.

## Google Search Console

Потрібні права/доступи:
1. Власник або редактор сайту `https://biztoolinsight.com.ua/` в Google Search Console.
2. Доступ до Search Console API через Google Cloud:
   - Увімкнений API "Google Search Console API".
   - Облікові дані служби (Service Account) або OAuth-ключі з правами `https://www.googleapis.com/auth/webmasters`.

Порядок запиту:
1. Власник сайту додає службовий обліковий запис як користувача в Search Console (додавання -> Користувачі).
2. Надати JSON-ключ для авторизації з середовища виконання (cron).
3. Зберегти шлях до ключа в конфігурації, наприклад `.env` з `GSC_KEY_PATH` та `GSC_SITE_URL`.
4. Перевірити доступ через верифікаційний запит до `webmasters/v3/sites`, наприклад:
   - `GET https://searchconsole.googleapis.com/webmasters/v3/sites`

## Bing Webmaster

Потрібні права/доступи:
1. Власник або співпрацівник сайту в Bing Webmaster Tools.
2. API-ключ Bing Webmaster API.

Порядок запиту:
1. Власник додає користувача в Bing Webmaster для цього сайту.
2. Створити API-ключ у налаштуваннях Bing Webmaster.
3. Перевірити через запит `/webmasters/api/ping?siteUrl=...` або об'єктні методи.
4. Зберегти ключ у конфігурації, наприклад `.env` з `BING_WEBMASTER_API_KEY`.

## Мінімальний набір даних для запуску перевірок

- Google:
  - `GSC_SITE_URL`
  - `GSC_KEY_PATH`
- Bing:
  - `BING_WEBMASTER_API_KEY`
  - `BING_SITE_URL`

## Чеклист передачі прав

1. [ ] Надати доступ до Google Search Console
2. [ ] Надати JSON-ключ Google для сервісного акаунта
3. [ ] Увімкнути Search Console API у Google Cloud
4. [ ] Надати доступ до Bing Webmaster для сайту
5. [ ] Надати API-ключ Bing Webmaster
6. [ ] Перевірити доступ через тестовий запит

## Статус доступу

- **Google Search Console**: очікується доступ.
  - Потрібно: додати сервісний обліковий запис як користувача у Search Console, надати JSON-ключ, вказати `GSC_SITE_URL` та `GSC_KEY_PATH` у `.env`.
- **Bing Webmaster**: очікується доступ.
  - Потрібно: надати доступ до сайту, створити API-ключ, вказати `BING_WEBMASTER_API_KEY` та `BING_SITE_URL` у `.env`.

При отриманні доступу оновити цей розділ актуальними датами та посиланнями на запити.

## Примітка

- Цей документ не змінює стандартні інструкції або інтеграції, якщо інше не зазначено явно.
- Якщо парсинсового доступ до панелей немає, продовжувати ручну перевірку через API неможливо.
- Після надання доступу першою дією буде перевірка списку URL та їх статусу індексації із записом результатів у `docs/indexing-protocol.md`.
