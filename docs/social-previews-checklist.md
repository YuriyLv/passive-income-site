# Social previews checklist — 2026-06-09

## Meta preview tags per article

Цей файл фіксує, яким чином соціальні картки/прев’ю для статей мусять бути налаштовані, і де саме перевірити/оновити.

## Search scope

Можна шукати за ключем: `og:image`.

## Articles

| Шлях | canonical | og:title | og:description | og:image |
| --- | ---: | ---: | ---: | ---: |
| `/posts/top-5-edo.html` | https://biztoolinsight.com.ua/posts/top-5-edo.html | Так | Так | Ні |
| `/posts/pos-for-cafe.html` | https://biztoolinsight.com.ua/posts/pos-for-cafe.html | Так | Так | Ні |
| `/posts/accounting-services.html` | https://biztoolinsight.com.ua/posts/accounting-services.html | Так | Так | Ні |
| `/posts/remote-work-tools.html` | https://biztoolinsight.com.ua/posts/remote-work-tools.html | Так | Так | Ні |
| `/posts/crm-for-small-business.html` | https://biztoolinsight.com.ua/posts/crm-for-small-business.html | Так | Так | Ні |

## Required additions

Для кожної статті додати в `<head>`:

```html
<meta property="og:image" content="/assets/images/og/<article-slug>.png">
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:image" content="/assets/images/og/<article-slug>.png">
```

Приклад:

```html
<meta property="og:image" content="/assets/images/og/top-5-edo.png">
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:image" content="/assets/images/og/top-5-edo.png">
```

## Asset requirements

-розмір: `1200x630 px`\n- формат: `PNG` або `JPG`\n- шлях: `/assets/images/og/` \n- дозвіл публікації: зображення має бути доступне за прямим URL (не залежати від шаблонів). \n