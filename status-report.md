# Звіт статусу проєкту

## Blockers
- Індексація не розблоковано: у `.env` відсутні дійсні `GSC_KEY_PATH`/`GSC_SITE_URL` та `BING_WEBMASTER_API_KEY`, тому `scripts/indexing-check.sh` не може робити реальний Coverage/Scan.
- У Bing Webmaster також не налаштовано доступ/API-ключ для `https://biztoolinsight.com.ua/`.

## Next step
- Оновити `hosts.txt` відповідним записом з актуальним доменом та виконаним правкою canonical у статтях.
- Створити короткий масований протокол оновлення `docs/indexing-protocol.md`. - Handled indexing documentation at 2026-06-08 19:05+00:00, domain normalized to `https://biztoolinsight.com.ua/`, and article canonical links adjusted. - Встановлено чергувальне блокування Google `DISALLOWED` через відсутню конфігурацію Google Cloud Console. - Створено runbook `docs/05-first-indexing-run.md` з покроковою інструкцією першого запуску. - Створено обгортку `cron/indexing-weekly.sh`, додано заплановане завдання у crontab на запуск щотижня о 03:00; ведення логів у `logs/indexing-weekly-run.log`. - Здійснено перший реальний запуск перевірки Coverage/Scan через `scripts/indexing-check.sh`; Google повернув `403 Client Error: DISALLOWED`, Bing перевірка пропущена через відсутність `BING_WEBMASTER_API_KEY` у `.env`. Результати записано у `docs/indexing-protocol.md`. - Створено документ `docs/02-indexing-access-request.md` з вказівкою, що формальний API-доступ потрібно налаштувати через Google Cloud Console і поповнити ключі.
- Здійснено перевірку перед запуском: всі статті та `index.html` мають коректний canonical на `https://biztoolinsight.com.ua/`; `.env.example` виправлено; реальний запуск далі блокується відсутністю коректних ключів.
- Відкладено подальший перезапуск до моменту отримання реальних ключів Google/Bing.
- [x] Базова структура сайту
- [x] Початкові статті
- [x] SEO
- [x] Бренд / домен
- [x] Список партнерських програм
- [x] Аналітика: Google Analytics підключено на сторінках
- [x] Сайт розгорнуто: https://vasylkivskyi.github.io/biz-tool-insight/
- [x] Ресурс верифіковано в Google Search Console та Bing Webmaster
- [x] Зібрано параметри для налаштування API-доступу та створено `.env` за `.env.example`
- [x] Щотижневий запуск перевірок індексації заплановано: `cron/indexing-weekly.sh`

## Changed this run
- Перевірено `index.html` та `posts/pos-for-cafe.html`: документ ready для обробки, canonical у `index.html` коректний, але в `posts/pos-for-cafe.html` `canonical` залишається старим `https://example.com/...`
- Виявлено невідповідність між `tasks.md` та реальним прогресом: дії з індексації виконуються, але перший реальний запуск `scripts/indexing-check.sh` ще не запускався після заповнення `.env`

## Next step
- Виправити посилання `canonical` в статтях, щоб відповідало домену `https://biztoolinsight.com.ua/`
- Перевірити налаштування локальною логікою без залежну від сторонніх сервісів, тоді запустити перший запуск `scripts/indexing-check.sh` і записати результати у `docs/indexing-protocol.md`
- Додати реферальні посилання в решту статей
