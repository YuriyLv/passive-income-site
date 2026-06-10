# Runbook: Перевірка доступу до індексації (Google Search Console + Bing Webmaster)

Цей документ використовується, коли отримано доступ до панелей/API.
Він дає exact кроки для першої перевірки Coverage/Scan і фіксації результатів.

## Передумови
- Збережено змінні середовища/ключі в конфігурації запуску (`.env`, secrets manager).
- Відомий `siteUrl` для Google та Bing:
  - `GSC_SITE_URL`
  - `BING_SITE_URL`

## Google Search Console

### 1. Перевірити, що обліковий запис має доступ до сайту
- API: `GET https://searchconsole.googleapis.com/webmasters/v3/sites`
- Очікуваний результат: масив сайтів, серед них `GSC_SITE_URL`.

### 2. Отримати перелік індексованих URL (URL Inspection)
- API: `POST https://searchconsole.googleapis.com/webmasters/v3/urlInspection/index:inspect`
- Цей метод дає актуальний статус конкретного URL.
- Для першої перевірки достатньо перевірити 10–50 URL з маппінгу сайту (sitemap.xml).

### 3. Отримати дані про індексацію (site URL)
- API: `GET https://searchconsole.googleapis.com/webmasters/v3/sites/siteUrl/searchAnalytics/query`
- Можна запитувати фільтр за `siteUrl` -> `page` для перевірки, чи сторінка в індексі.

### 4. Вимоги до запису у протокол (`docs/indexing-protocol.md`)
- Дата перевірки.
- Система: Google Search Console.
- Статус доступу (доступно / обмежено / помилка).
- Coverage/scan: кількість перевірених URL / проіндексованих / з помилками.
- Проблеми: текстове опис або код помилки.
- Дії: що було виконано.


## Bing Webmaster

### 1. Перевірити сайт через API
- API: `POST /webmasters/api/ping?siteUrl=...`
- Очікуваний результат: успішна відповідь, що сайт взаємодіє з Bing Webmaster.

### 2. Отримати статус індексації URL
- API: `GET /webmasters/api/crawl/Scan?siteUrl=...`
- Це дасть перелік URL та їх стан сканування/індексації.

### 3. Вимоги до запису у протокол
- Аналогічно до Google: дата, система, статус, coverage/scan, проблеми, дії.


## Перевірка без API (fallback)
Якщо API доступ недоступний:
- Зробити ручну перевірку через браузер на сторінках GSC/Bing.
- Зробити запити через site: у пошукових системах для топ-URL.
- Прибрати статус "потребує доступу" після фіксації результатів.
