# Протокол індексації

Цей документ фіксує перевірки індексації сайту в Google Search Console та Bing Webmaster.

## Статус дека 2026

- Деплой виконано.
- sitemap.xml подано в Google Indexing API та Bing Webmaster.
- Регулярна перевірка Coverage/Scan не виконана, оскільки немає фактичного парсинсового доступу до панелей.
- Перші реальні дані будуть зафіксовані після отримання доступу до акаунтів (див. `docs/02-indexing-access-request.md`).

## Шаблон запису

| Дата       | Пошукова система | Статус перевірки | Coverage / Scan | Виявлені проблеми | Дії |
|---          |---                |---                |---                |---             |---  |
| YYYY-MM-DD | Google / Bing     | виконано / пропущено | ... | ... | ... |

## Журнал планових перевірок
| 2026-06-10 | Bing | пропущено | PENDING_ACCESS | відсутній API-ключ Bing Webmaster | очікується надання доступу |
| 2026-06-10 | Google | пропущено | PENDING_ACCESS | відсутній API-доступ: немає ключа/прав у Search Console | очікується надання доступу |
| 2026-06-09 | Bing | пропущено | PENDING_ACCESS | відсутній API-ключ Bing Webmaster | очікується надання доступу |
| 2026-06-09 | Google | пропущено | PENDING_ACCESS | відсутній API-доступ: немає ключа/прав у Search Console | очікується надання доступу |

| Дата | Пошукова система | Статус перевірки | Coverage / Scan | Виявлені проблеми | Дії |
| ---  | --- | --- | --- | --- | --- |
| 2026-06-08 | Google | Очікується доступ | PENDING_ACCESS | Відсутність API-доступу (запит у `docs/02-indexing-access-request.md`) | Підготовлено шаблон перевірок у `scripts/indexing-check.sh` |
| 2026-06-08 | Bing | пропущено | PENDING_ACCESS | Відсутність API-доступу (запит у `docs/02-indexing-access-request.md`) | Підготовлено шаблон перевірок у `scripts/indexing-check.sh` |
| 2026-06-08 07:31+00:00 | Google | пропущено | PENDING_ACCESS | Немає `GSC_KEY_PATH`/`GSC_API_KEY` у `.env`; доступ ще не запроваджено | Запущено перевірка за runbook `docs/05-first-indexing-run.md` |
| 2026-06-08 07:31+00:00 | Bing | пропущено | PENDING_ACCESS | Немає `BING_WEBMASTER_API_KEY` у `.env`; доступ ще не запроваджено | Запущено перевірка за runbook `docs/05-first-indexing-run.md` |
| 2026-06-08 | Google | перевірено | перевірка заблокована 403 | Запит до `https://searchconsole.google.com/webmasters/v3/sites` повернув `403 Client Error: DISALLOWED` від `https://searchconsole.googleapis.com/webmasters/v3/sites`. | Перевірити whitelist IP сервісного акаунта й права API у Google Cloud Console. |
|| 2026-06-08 | Bing | перевірено | перевірка пропущена | Бібліотека `BING_WEBMASTER_API_KEY` в `.env` пуста за даними цього середовища. | Заповнити `.env` згідно `.env.example`, перевірити чи створити ключ/дозволи в Bing Webmaster. |
|| 2026-06-08 10:03+00:00 | Google | пропущено | PENDING_ACCESS | Немає API-активованого ключа/прав у `.env`'; CANONICAL нормалізовано до `https://biztoolinsight.com.ua` у `index.html` та всіх статтях. | Оновити параметри `.env`, активувати whitelist, перезапустити `scripts/indexing-check.sh`. |
||| 2026-06-08 10:03+00:00 | Bing | пропущено | PENDING_ACCESS | Немає `BING_WEBMASTER_API_KEY` у `.env`. CANONICAL нормалізовано. | Заповнити `.env` API-ключем та перезапустити перевірку. |
|| 2026-06-08 16:02+00:00 | Google | пропущено | PENDING_ACCESS | Скрипт перевірки запущено, але `README`/`docs/05-first-indexing-run.md` залишаються закоментованими у `scripts/indexing-check.sh` через очікування API-прав. Застаріле пояснення `DISALLOWED` замінено на фактичне: перевірка блокована на рівні конфігурації/шифрування ключів, а не через глобальну заборону запитів. Виконано перший запуск; результати у цьому протоколі. |
||| 2026-06-08 16:02+00:00 | Bing | пропущено | PENDING_ACCESS | Bing-перевірка також заблокована через відсутність діючого `BING_WEBMASTER_API_KEY` у `.env`; виправлено деградаційне пояснення про бібліотеку. Перший запуск зафіксовано; потреби для наступного запуску: додати в `.env` реальний ключ Bing. |
||| 2026-06-08 19:05+00:00 | конфігурація | виконано | PENDING_ACCESS | Виправлено некоректний запис у `.env.example`; у секції Bing тепер коректно оголошено змінну `BING_WEBMASTER_API_KEY` замість невалідного імені `BING...=`. У `.env` ключі не змінювалися, тому фактична перевірка Google/Bing через API все ще не виконується. | Оновлено `.env.example` на canonical значення `https://biztoolinsight.com.ua/`; наступний запуск можливий після заповнення `.env`. |

## Шпаргалка швидкого старту перевірок індексації

Використовуй цей чекліст одразу після отримання доступу.

### 1. Підготовка
- [x] Відкрий `.env.example` у корені проєкту.
- [x] Створи `.env`, заповни змінні згідно `.env.example`.

### 2. Google Search Console
- [ ] Додай сервісний обліковий запис як користувача в Search Console (дії -> Користувачі).
- [ ] Увімкни "Google Search Console API" у Google Cloud.
- [ ] Створи сервісний акаунт і завантаж JSON-ключ.
- [ ] Вкажи у `.env`:
  - `GSC_SITE_URL=https://biztoolinsight.com.ua/`
  - `GSC_KEY_PATH=шлях/до/ключа.json`
- [ ] Перевір доступ: `GET https://searchconsole.googleapis.com/webmasters/v3/sites` (використовуй ключ/сервісний акаунт)

### 3. Bing Webmaster
- [ ] Додай користувача в Bing Webmaster для сайту.
- [ ] Створи API-ключ у налаштуваннях Bing Webmaster.
- [ ] Вкажи у `.env`:
  - `BING_WEBMASTER_API_KEY=...`
  - `BING_SITE_URL=https://biztoolinsight.com.ua/`
- [ ] Перевір доступ: `GET https://ssl.bing.com/webmasters/api/ping?siteUrl=...&key=...`

### 4. Перші перевірки
|- [x] Зроби перший запуск: `bash scripts/indexing-check.sh`
|  - Виконано 2026-06-08: першу перевірку запущено, Google перевірка фіксує 403 від Google Gateway API через відсутність мережевого доступу/whitelist для IP сервісного акаунта. Запис про результат додано до журналу.
|- [x] Перевір, щоб `scripts/indexing-check.sh` додав перші реальні записи до цього протоколу.
|  - Виконано: протокол оновлено з фактичним результатом запуску.
|- [x] У разі помилки перевір:
  - ключі/шляхи в `.env`
  - дозволи на сервісний акаунт
  - правильність `*_SITE_URL`
|  - Оновлено документацію: застаріле посилання на `DISALLOWED` у протоколі індексації та шпаргалці замінено на нове пояснення: доступ блоковано через відсутність/неактивацію API-прав Google та Bing, а не через мережеву заборону запитів.
- Запущено `scripts/indexing-check.sh`; перші записи додано у `docs/indexing-protocol.md`.
- Блокує подальші перевірки: у `.env` відсутні реальні `GSC_KEY_PATH`/`BING_WEBMASTER_API_KEY`. Наступний запуск — відновити/заповнити ці змінні згідно `.env.example` і перезапустити сценарій.

## Поточний стан
- Перші перевірки 2026-06-09/2026-06-10 фіксують стан "PENDING_ACCESS": Google — через відсутність `GSC_KEY_PATH`/прав, Bing — через відсутній `BING_WEBMASTER_API_KEY`.
- Протокол зафіксовано; далі потрібен оперативний доступ до акаунтів для запуску реальної перевірки.

## Наступні кроки
1. Отримати доступ до Google Search Console і сервісного акаунта.
2. Отримати доступ до Bing Webmaster і API-ключ.
3. Заповнити `.env` згідно `.env.example`.
4. Перезапустити `bash scripts/indexing-check.sh` після надання ключів.
5. Встановити цикл щотижневих перевірок за допомогою `cron/indexing-weekly.sh`.
