import os, re
from pathlib import Path

root = Path('/home/deploy/projects/passive-income-site')
posts = root/'posts'
count = 0
for path in sorted(posts.glob('*.html')):
    slug = path.stem
    og_png = root/'assets'/'images'/'og'/f'{slug}.png'
    if not og_png.exists():
        continue
    text = path.read_text(encoding='utf-8')
    new_text = text
    new_text = re.sub(r'https://images\.unsplash\.com/[^"\']+', 'https://yuriylv.github.io/passive-income-site/assets/images/og/' + slug + '.png', new_text)
    new_text = new_text.replace('/assets/img/' + slug + '-chart.png', 'https://yuriylv.github.io/passive-income-site/assets/img/' + slug + '-chart.png')
    new_text = re.sub(r'(?<=src=")/assets/img/([^"]+)"', r'https://yuriylv.github.io/passive-income-site/assets/img/\1"', new_text)
    new_text = re.sub(r'<link rel="canonical" href="/([^"]+)"', r'<link rel="canonical" href="https://yuriylv.github.io/passive-income-site/\1"', new_text)
    if new_text != text:
        path.write_text(new_text, encoding='utf-8')
        count += 1
print('updated', count)
