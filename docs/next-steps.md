# Наступні кроки індексації

## Приклад `.env`

Скопіюйте приклад у локальний файл `.env` та заповніть реальними даними.

```env
GSC_KEY_PATH=keys/gsc-service-account.json
GSC_SITE_URL=https://biztoolinsight.com.ua/
GSC_API_KEY=
BING_WEBMASTER_API_KEY=
BING_SITE_URL=https://biztoolinsight.com.ua/
```

## Команда перезапуску перевірки

```bash
bash scripts/indexing-check.sh
```

## Умови реальної перевірки Google

- Створено/підтверджено сервісний акаунт у Google Cloud.
- Увімкнено API Google Search Console.
- JSON-ключ збережено у файл, вказаному в `GSC_KEY_PATH`.
- Сайт додано та підтверджено в Google Search Console.
- `GSC_SITE_URL` відповідає canonical домену.

## Умови реальної перевірки Bing

- Отримано `BING_WEBMASTER_API_KEY` у Bing Webmaster Tools.
- Сайт додано в Bing Webmaster.
- `BING_SITE_URL` відповідає canonical домену.
