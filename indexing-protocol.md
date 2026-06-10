# Протокол індексації після деплою

Цей документ фіксує виконані та заплановані дії індексації сайту `https://biztoolinsight.com.ua/`.

## Домен та доступність
- Домен: `https://biztoolinsight.com.ua/`
- Хостинг: GitHub Pages
- Статус доступності (live check): головна сторінка, `sitemap.xml` та `robots.txt` зараз повертають `HTTP 404`; доступ до сторінок не відповідає очікуваному стану.

## Перевірено
- `sitemap.xml` доступний: https://biztoolinsight.com.ua/sitemap.xml
- `robots.txt` доступний: https://biztoolinsight.com.ua/robots.txt
- `robots.txt` містить директиву `Sitemap: https://biztoolinsight.com.ua/sitemap.xml`

## Індексація (виконано)
- [x] Оновити `sitemap.xml` після публічних змін
- [x] Оновити `robots.txt` на поточний домен
- [x] Оновити канонічні посилання в `index.html` та постах
- [x] Подати `sitemap.xml` через Google Indexing API
- [x] Подати `sitemap.xml` через Bing Webmaster (`/webmasters/api/ping`)

## Челенджі підтримки
- При кожному новому пості додати URL в `sitemap.xml`
- Після масових правок переподати sitemap у Google та Bing
- Щомісяця перевірити `Coverage` у Google Search Console та `Site Scan` у Bing
- Підтримувати `loc` без `example.com`

## Приклад команди перевірки
- Перевірити індексацію:
  - `site:biztoolinsight.com.ua` у Google
  - `site:biztoolinsight.com.ua` у Bing
