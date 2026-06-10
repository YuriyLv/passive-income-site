from PIL import Image, ImageDraw, ImageFont
import os

size = (1200, 630)

feed = [
    ("top-5-edo.png", "#EDO сервіси 2026", (66, 133, 244)),
    ("pos-for-cafe.png", "POS для кафе", (52, 168, 83)),
    ("accounting-services.png", "Бухгалтерські сервіси", (251, 188, 5)),
    ("remote-work-tools.png", "Інструменти для віддаленої роботи", (234, 67, 53)),
    ("crm-for-small-business.png", "CRM для малого бізнесу", (156, 39, 176)),
    ("pos-comparison.png", "Порівняння POS", (0, 172, 193)),
    ("document-security.png", "Безпека документів", (255, 152, 0)),
    ("saas-reliability.png", "Надійність SaaS", (96, 125, 139)),
    ("crm-startups.png", "CRM для стартапів", (233, 30, 99)),
    ("how-to-choose-payment-gateway.png", "Платіжний шлюз 2026", (0, 150, 136)),
]

font_paths = [
    "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf",
    "/usr/share/fonts/truetype/liberation/LiberationSans-Bold.ttf",
    "/usr/share/fonts/truetype/freefont/FreeSansBold.ttf",
]

font_path = next((p for p in font_paths if os.path.exists(p)), None)

for filename, title, color in feed:
    img = Image.new("RGB", size, color)
    draw = ImageDraw.Draw(img)
    font = ImageFont.truetype(font_path, 64) if font_path else ImageFont.load_default()
    font_small = ImageFont.truetype(font_path, 36) if font_path else ImageFont.load_default()

    bbox = draw.textbbox((0, 0), title, font=font)
    tw, th = bbox[2] - bbox[0], bbox[3] - bbox[1]
    draw.text(((size[0] - tw) / 2, (size[1] - th) / 2 - 20), title, fill=(255, 255, 255), font=font)

    domain = "biztoolinsight.com.ua"
    bbox2 = draw.textbbox((0, 0), domain, font=font_small)
    dw, dh = bbox2[2] - bbox2[0], bbox2[3] - bbox2[1]
    draw.text(((size[0] - dw) / 2, (size[1] - th) / 2 + 80), domain, fill=(255, 255, 255, 180), font=font_small)

    out = os.path.join(os.path.dirname(__file__), filename)
    img.save(out)
    print(f"Created {out}")

print("Done")
