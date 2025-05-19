# 🧠 dexwatch

copy a contract address. open's the tokens dexscreener. that’s it.

---

## what is this?

dexwatch is a tiny mac-only utility that runs quietly in the background.  
every time you copy a base or solana contract address, it automatically opens the dexscreener page in your browser.

no extensions. no UI. no bullshit.

---

what this does
- sets up a clean ~/dexwatch folder
- installs dependencies in a virtual environment
- launches the watcher in the background
- starts reacting to anything you copy

you’ll see your browser open dexscreener every time you copy a base or solana address.

---

## how to install (1 line)

paste this in your terminal:

```bash
curl -s https://raw.githubusercontent.com/heettike/dexwatch/refs/heads/main/install.sh | bash

--
# to stop:
pkill -f dexwatch.py

# to restart:
bash ~/dexwatch/run_dexwatch.sh

for now
- works only on macOS
- depends on python3 and pyperclip
- uses polling (no clipboard_monitor for now)


