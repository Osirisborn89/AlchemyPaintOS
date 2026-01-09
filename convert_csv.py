import json
import ast

data = []

# Read entire CSV as raw text
with open('data/factions_lore.csv', 'r', encoding='utf-8') as f:
    lines = f.readlines()

# The CSV file has:
# "faction","lore_md","key_themes","notable_units","source_urls","scheme_note"
# Where lore_md is a LONG string with actual newlines inside quotes

current_faction = None
current_lore = ''
in_lore_field = False
line_buffer = []

for line in lines[1:]:  # Skip header
    line = line.rstrip('\r\n')
    
    # Try to detect faction start (unquoted field at line start)
    if line.startswith('"') and '","' in line:
        # This might be a new faction
        try:
            # Extract fields properly
            parts = []
            current_part = ''
            in_quotes = False
            i = 0
            
            while i < len(line):
                c = line[i]
                if c == '"':
                    if i+1 < len(line) and line[i+1] == '"':
                        current_part += '"'
                        i += 2
                    else:
                        in_quotes = not in_quotes
                        i += 1
                elif c == ',' and not in_quotes:
                    parts.append(current_part)
                    current_part = ''
                    i += 1
                else:
                    current_part += c
                    i += 1
            
            parts.append(current_part)
            
            if len(parts) >= 6:
                data.append({
                    'faction': parts[0],
                    'lore': parts[1],
                    'themes': parts[2],
                    'units': parts[3],
                    'urls': parts[4],
                    'scheme': parts[5]
                })
        except:
            pass

with open('src/data/factions.json', 'w', encoding='utf-8') as f:
    json.dump(data, f, ensure_ascii=False, indent=2)

print(f'✓ Converted {len(data)} factions')
for d in data[:2]:
    lore_len = len(d['lore'])
    lore_lines = d['lore'].count('\n') + 1
    print(f'  {d[\"faction\"]}: {lore_len} chars, {lore_lines} lines')
