# Audit: індексаційний протокол та доступ (2026-06-08)

Цей документ фіксує де-факто стан конфігурації, доступів та результатів перевірок індексації на момент останнього запуску. Він доповнює `docs/indexing-protocol.md` і не замінює його.

## 1. Деплой та доступність
- Актуальний домен в документах: `https://biztoolinsight.com.ua/`.
- Деплой зафіксовано у `hosts.txt`: GitHub Pages на `https://biztoolinsight.com.ua/`.
- Локальна перевірка: `python3 -m http.server 8080` у корені проєкту показує сторінки та sitemap.

## 2. Конфігурація середовища
- `.env.example` присутній і містить параметри для Google Search Console та Bing Webmaster.
- `.env` створено у попередньому кроці, але вміст не читається через обмеження безпеки.
- Сценарій перевірок `scripts/indexing-check.sh` очікує:
  - `GSC_KEY_PATH` (або інший спосіб авторизації) для Google
  - `BING_WEBMASTER_API_KEY` для Bing

## 3. Фактичний доступ до панелей індексації
- Google Search Console:
  - Профіль створено; ресурс верифіковано.
  - Перші реальні запуски скрипта фіксують `403 Client Error: DISALLOWED`.
  - Блокувальна причина: відсутній мережевий доступ/whitelist для сервісного акаунта в Google Cloud Console або неактивований API.

- Bing Webmaster:
  - Перші реальні запуски пропущені через порожній `BING_WEBMASTER_API_KEY` у `.env`.
  - Блокувальна причина: ключ не заповнений.

## 4. Результати останніх запусків
- Згідно з `docs/indexing-protocol.md`:
  - Google: `PENDING_ACCESS`, потім `перевірено` + `403 DISALLOWED`.
  - Bing: `PENDING_ACCESS`, перевірка пропущена.

## 5. Відповідність конфігурації домену
- `index.html` та всі пости містять canonical на `https://biztoolinsight.com.ua/`.
- `sitemap.xml` та `robots.txt` оновлені на актуальний домен.

## 6. Заплановані необхідні дії
1. Надати/активувати Google Search Console API: прав доступу, whitelist IP для сервісного акаунта, перевірити налаштування проекту в Google Cloud Console.
2. Заповнити `.env` згідно `.env.example`:
   - `GSC_SITE_URL`
   - `GSC_KEY_PATH`
   - `BING_WEBMASTER_API_KEY`
   - `BING_SITE_URL`
3. Перезапустити `bash scripts/indexing-check.sh` і переконатися, що `docs/indexing-protocol.md` отримує реальні значення coverage/scan.
4. Повторити перевірки після зміни конфігурації.

## 7. Статус аудиту
- Відповідна конфігурація: частково готова.
- Доступ до індексаційних систем: не відкрито.
- Реальна перевірка Coverage/Scan: не виконана.
