import os
import csv

os.makedirs('src/lore', exist_ok=True)

csv.field_size_limit(500000)

with open('data/factions_lore.csv', 'r', encoding='utf-8') as f:
    reader = csv.DictReader(f)
    count = 0
    for row in reader:
        faction = row['faction'].strip()
        lore = row['lore_md']
        
        if not faction or not lore:
            continue
            
        filename = f'src/lore/{faction.replace(" ", "_")}.md'
        with open(filename, 'w', encoding='utf-8') as md:
            md.write(lore)
        
        count += 1
        print(f'✓ {faction}: {len(lore)} chars')

print(f'\nDone! Extracted {count} factions')
