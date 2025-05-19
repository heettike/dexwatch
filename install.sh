#!/bin/bash

mkdir -p ~/dexwatch
cd ~/dexwatch

cat > dexwatch.py << 'EOF'
#!/usr/bin/env python3
# dexwatch.py - paste your final Dexwatch code here
import os
import re
import sys
import time
import webbrowser

try:
    import clipboard_monitor
    CLIPBOARD_MONITOR_AVAILABLE = True
    print("[dexwatch] clipboard_monitor imported successfully", flush=True)
except ImportError:
    import pyperclip
    CLIPBOARD_MONITOR_AVAILABLE = False
    print("[dexwatch] clipboard_monitor NOT available, using pyperclip fallback", flush=True)

BASE_REGEX = r"^0x[a-fA-F0-9]{40}$"
SOLANA_REGEX = r"^[1-9A-HJ-NP-Za-km-z]{32,44}$"
LOCK_FILE = "/tmp/dexwatch.lock"

def is_base_address(text):
    return bool(re.fullmatch(BASE_REGEX, text))

def is_solana_address(text):
    return bool(re.fullmatch(SOLANA_REGEX, text))

class Dexwatcher:
    def __init__(self):
        print("[dexwatch] Dexwatcher initialized", flush=True)
        self.check_singleton()

    def check_singleton(self):
        if os.path.exists(LOCK_FILE):
            try:
                with open(LOCK_FILE, 'r') as f:
                    pid = int(f.read())
                os.kill(pid, 0)
                print("[dexwatch] Lock exists and is alive, exiting.", flush=True)
                sys.exit(0)
            except:
                os.remove(LOCK_FILE)
        with open(LOCK_FILE, 'w') as f:
            f.write(str(os.getpid()))

    def handle_clipboard(self, text):
        text = text.strip()
        if is_base_address(text):
            url = f"https://dexscreener.com/base/{text}"
            print(f"[dexwatch] opening base URL: {url}", flush=True)
            webbrowser.open(url)
        elif is_solana_address(text):
            url = f"https://dexscreener.com/solana/{text}"
            print(f"[dexwatch] opening solana URL: {url}", flush=True)
            webbrowser.open(url)

    def run(self):
        last = ""
        while True:
            try:
                text = pyperclip.paste().strip()
                if text != last:
                    last = text
                    self.handle_clipboard(text)
                time.sleep(0.5)
            except KeyboardInterrupt:
                break

if __name__ == "__main__":
    watcher = Dexwatcher()
    watcher.run()

EOF

cat > run_dexwatch.sh << 'EOF'
#!/bin/bash
source ~/dexwatch/venv/bin/activate
python ~/dexwatch/dexwatch.py >> ~/dexwatch.log 2>&1

EOF
chmod +x run_dexwatch.sh

python3 -m venv venv
source venv/bin/activate
pip install pyperclip

nohup bash run_dexwatch.sh &
echo "✅ dexwatch is now running. copy any base or solana contract to test."
