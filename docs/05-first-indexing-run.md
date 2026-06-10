# Шпаргалка першого запуску перевірок індексації

## Передумови
1. Створено `.env` на підставі `.env.example`.
2. Надано фактичний доступ у Google Search Console та/або Bing Webmaster.
3. Отримано: `GSC_KEY_PATH` або право `GSC_API_KEY`, а також `BING_WEBMASTER_API_KEY`.
4. Сайт доступний публічно за https://biztoolinsight.com.ua/.

## Дії
1. Перевірте синтаксис: `bash -n scripts/indexing-check.sh`
2. За потреби заповніть `.env`: `cp .env.example .env && vi .env`
3. Захистіть файл: `chmod 600 .env`
4. Виконайте перевірку:
   - Google: `source .env && GSC_KEY_PATH="keys/gsc-service-account.json" bash scripts/indexing-check.sh | tail -n 40`
   - Bing: `source .env && BING_WEBMASTER_API_KEY="..." bash scripts/indexing-check.sh | tail -n 40`
5. Результати додаються у `docs/indexing-protocol.md` автоматично.

## Перевірка
- Файл `docs/indexing-protocol.md` містить рядок з поточною датою.
- Якщо ключ не заданий: запис з `PENDING_ACCESS`.
- Якщо ключ заданий: запис з `TODO` або зісправленим статусом.

## Rollback
- Відкат змін `.env`: `git checkout -- .env` або відновити архів.
- Безпека: не комітьте `.env`.
