# Протокол індексації: fallback та конфігурація

Цей документ описує canonical-домен для всіх індексаційних перевірок та очікуваний формат конфігурації `.env`.

## Актуальний canonical домен
- `https://biztoolinsight.com.ua/`

## Очікуваний формат `.env`
```
GSC_KEY_PATH=
GSC_SITE_URL="https://biztoolinsight.com.ua/"
BING_WEBMASTER_API_KEY=***
BING_SITE_URL="https://biztoolinsight.com.ua/"
```

## Нормалізований canonical
- активний canonical: `https://biztoolinsight.com.ua/`
- застаріле значення видалено; обидва інструменти використовують однаковий canonical

## Примітка
- Файл `.env` є конфіденційним і не включається у репозиторій.
- Якщо canonical відрізняється від `https://biztoolinsight.com.ua/`, замініть значення в `GSC_SITE_URL` та `BING_SITE_URL` в `.env` та `.env.example`.
- Для повного запуску `scripts/indexing-check.sh` потрібні дійсні ключі: `GSC_KEY_PATH` і `BING_WEBMASTER_API_KEY`. Без ключів перевірки залишаться у стані `PENDING_ACCESS`.
