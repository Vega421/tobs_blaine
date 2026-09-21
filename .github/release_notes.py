"""Builds the GitHub release notes for one version from CHANGELOG.md.

Usage: python3 .github/release_notes.py 1.3.1 > notes.md
"""
import re
import sys

REPO = "Vega421/tobs_blaine"
FRAMEWORK = "vRP"
ZIP = "tobs_blaine-vrp-v{version}.zip"
DEPENDENCY = "vrp"
ITEMS = "Add `id_card_f` to `vrp/cfg/items.lua`."
DOCS = "https://vega421.github.io/scripts/tobs-blaine/"

version = sys.argv[1].lstrip("v")
changelog = open("CHANGELOG.md", encoding="utf-8").read()
match = re.search(r"^## v?" + re.escape(version) + r"\b.*?\n(.*?)(?=^## |\Z)", changelog, re.S | re.M)
changes = match.group(1).strip() if match else "See the [changelog](https://github.com/{}/blob/main/CHANGELOG.md).".format(REPO)

print(f"""## What's new

{changes}

## Install

1. Download **`{ZIP.format(version=version)}`** below.
2. Delete your old `tobs_blaine` folder, then unzip this one into `resources/`.
3. {ITEMS}
4. Add `ensure tobs_blaine` to `server.cfg` below `ensure {DEPENDENCY}`.

**Requires:** {DEPENDENCY} · [ox_lib](https://github.com/overextended/ox_lib) (recommended) · [ox_target](https://github.com/overextended/ox_target) (optional)

---

📖 [Documentation]({DOCS}) · 📝 [Full changelog](https://github.com/{REPO}/blob/main/CHANGELOG.md) · 🐛 [Report a problem](https://github.com/{REPO}/issues)""")
