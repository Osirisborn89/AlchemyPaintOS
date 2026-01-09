from http.server import HTTPServer, SimpleHTTPRequestHandler
import os
import json
import urllib.parse


os.chdir(os.path.dirname(os.path.abspath(__file__)))


class LoreHandler(SimpleHTTPRequestHandler):
    def do_GET(self):
        if self.path.startswith('/api/faction/'):
            faction_name = urllib.parse.unquote(self.path.split('/')[-1])
            self.serve_faction_lore(faction_name)
        else:
            super().do_GET()
    
    def serve_faction_lore(self, faction_name):
        try:
            filename = f'lore/{faction_name}.md'
            
            if not os.path.exists(filename):
                faction_name_alt = faction_name.replace('_', ' ')
                filename = f'lore/{faction_name_alt}.md'
            
            print(f'Loading: {filename}')
            
            with open(filename, 'r', encoding='utf-8') as f:
                lore = f.read()
            
            units = ''
            scheme = ''
            
            units_idx = lore.find('## Notable Units')
            scheme_idx = lore.find('## Paint Scheme')
            
            if units_idx != -1 and scheme_idx != -1:
                units = lore[units_idx:scheme_idx].strip()
                scheme = lore[scheme_idx:].strip()
                lore = lore[:units_idx].strip()
            elif units_idx != -1:
                units = lore[units_idx:].strip()
                lore = lore[:units_idx].strip()
                scheme = 'Classic'
            elif scheme_idx != -1:
                scheme = lore[scheme_idx:].strip()
                lore = lore[:scheme_idx].strip()
                units = 'No units data available'
            else:
                units = 'No units data available'
                scheme = 'Classic'
            
            response = {
                'faction': faction_name,
                'lore': lore,
                'themes': '',
                'units': units,
                'scheme': scheme
            }
            
            self.send_response(200)
            self.send_header('Content-type', 'application/json; charset=utf-8')
            self.send_header('Access-Control-Allow-Origin', '*')
            self.end_headers()
            self.wfile.write(json.dumps(response, ensure_ascii=False).encode('utf-8'))
            print(f'✓ Served: {faction_name}')
            
        except FileNotFoundError:
            print(f'✗ Not found: {filename}')
            self.send_response(404)
            self.send_header('Content-type', 'application/json')
            self.send_header('Access-Control-Allow-Origin', '*')
            self.end_headers()
            self.wfile.write(json.dumps({'error': 'Not found'}).encode())
        except Exception as e:
            print(f'✗ Error: {e}')
            self.send_response(500)
            self.send_header('Content-type', 'application/json')
            self.send_header('Access-Control-Allow-Origin', '*')
            self.end_headers()
            self.wfile.write(json.dumps({'error': str(e)}).encode())


server = HTTPServer(('0.0.0.0', 8000), LoreHandler)
print('Server running at http://localhost:8000')
server.serve_forever()
