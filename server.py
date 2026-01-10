#!/usr/bin/env python3
import http.server, socketserver, os, sys, argparse, time


class Handler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory="src", **kwargs)
    
    def end_headers(self):
        self.send_header('Cache-Control', 'no-store, no-cache, must-revalidate, max-age=0')
        self.send_header('Pragma', 'no-cache')
        self.send_header('Expires', '0')
        super().end_headers()
    
    def do_GET(self):
        if self.path == '/': self.path = '/index.html'
        super().do_GET()


if not os.path.isdir('src'):
    print("Error: src folder not found")
    sys.exit(1)


parser = argparse.ArgumentParser()
parser.add_argument('--port', type=int, default=8000)
parser.add_argument('--host', default='localhost')
args = parser.parse_args()

# Cache buster - changes on every server restart
CACHE_BUST = str(int(time.time()))

with socketserver.TCPServer((args.host, args.port), Handler) as httpd:
    print(f"🎨 AlchemyPaintOS Server")
    print(f"✓ http://{args.host}:{args.port}")
    print(f"✓ Cache Buster: {CACHE_BUST}")
    print(f"✓ Press Ctrl+C to stop\n")
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        print("\n✓ Stopped")
