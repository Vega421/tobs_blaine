<div align="center">

# tobs_blaine · vRP

**Paleto Bay bank heist for FiveM**

[![Release](https://img.shields.io/github/v/release/Vega421/tobs_blaine?style=flat-square&color=ff6b2c&label=release)](https://github.com/Vega421/tobs_blaine/releases/latest)
[![License](https://img.shields.io/github/license/Vega421/tobs_blaine?style=flat-square)](LICENSE)
[![Docs](https://img.shields.io/badge/docs-read-ff6b2c?style=flat-square)](https://vega421.github.io/script-docs/scripts/tobs-blaine/)

[**Download**](https://github.com/Vega421/tobs_blaine/releases/latest) · [Documentation](https://vega421.github.io/script-docs/scripts/tobs-blaine/) · [Changelog](CHANGELOG.md) · [Report a problem](https://github.com/Vega421/tobs_blaine/issues)

</div>

---

Hack the security panel, open the vault and grab the cash from three trolleys before the police arrive.

## Features

- Hacking minigame, police alerts and three cash trolleys
- Server-side anti-cheat, Discord logs and an admin reset command
- Uses ox_lib, ox_target and your dispatch script when you have them
- Rewards as cash or items, optional thermite-style vault step
- English and Danish, easy to translate, more banks from the config
- Almost no performance cost when nobody is near the bank

## Install

1. Download the zip from [Releases](https://github.com/Vega421/tobs_blaine/releases/latest) and unzip it into `resources/`.
2. Add `id_card_f` to `vrp/cfg/items.lua`.
3. Add `ensure tobs_blaine` to `server.cfg` below `ensure vrp`.

See the [installation guide](https://vega421.github.io/script-docs/scripts/tobs-blaine/installation/) for details.

**Requires:** vRP · [ox_lib](https://github.com/overextended/ox_lib) (recommended) · [ox_target](https://github.com/overextended/ox_target) (optional)

Using a different framework? See the [ESX version](https://github.com/Vega421/tobs_blaineESX).

## Credits and license

Made by Vega, based on [utkuali/Fleeca-Bank-Heists](https://github.com/utkuali/Fleeca-Bank-Heists). Licensed under [GPL-3.0](LICENSE): you can use, change and share it, as long as your version stays open source under GPL-3.0 and keeps the credits.
