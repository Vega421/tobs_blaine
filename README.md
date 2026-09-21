> [!IMPORTANT]
> **This repository has moved to [Vega421/tobs_bankrobbery](https://github.com/Vega421/tobs_bankrobbery).** tobs_bankrobbery is the same heist in one resource for Qbox, ESX, QBCore and vRP. Download the [latest release](https://github.com/Vega421/tobs_bankrobbery/releases/latest) and see the [upgrade steps](https://vega421.github.io/scripts/tobs-bankrobbery/installation/#updating). This repository is archived and no longer updated.

<div align="center">

# tobs_blaine · vRP

**Paleto and Fleeca bank heists for FiveM**

[![Release](https://img.shields.io/github/v/release/Vega421/tobs_blaine?style=flat-square&color=ff6b2c&label=release)](https://github.com/Vega421/tobs_blaine/releases/latest)
[![License](https://img.shields.io/github/license/Vega421/tobs_blaine?style=flat-square)](LICENSE)
[![Docs](https://img.shields.io/badge/docs-read-ff6b2c?style=flat-square)](https://vega421.github.io/scripts/tobs-blaine/)

[**Download**](https://github.com/Vega421/tobs_blaine/releases/latest) · [Documentation](https://vega421.github.io/scripts/tobs-blaine/) · [Changelog](CHANGELOG.md) · [Report a problem](https://github.com/Vega421/tobs_blaine/issues)

</div>

---

Hack the security panel, open the vault and grab the cash from three trolleys before the police arrive.

## Features

- Paleto Bay plus all 6 Fleeca banks
- Laptop hack, thermite, bank alarm and drillable deposit boxes
- Cash, gold and diamond trolleys, with a live loot counter
- Server-side anti-cheat, Discord logs and an admin reset command
- Uses ox_lib, ox_target and your dispatch script when you have them
- Rewards as cash or items, optional thermite-style vault step
- English and Danish, easy to translate, add your own banks from the config
- Minimum crew size, one-heist-at-a-time, and no heists right before a restart
- Almost no performance cost when nobody is near the bank

## Install

1. Download the zip from [Releases](https://github.com/Vega421/tobs_blaine/releases/latest) and unzip it into `resources/`.
2. Add `id_card_f` to `vrp/cfg/items.lua`.
3. Add `ensure tobs_blaine` to `server.cfg` below `ensure vrp`.

See the [installation guide](https://vega421.github.io/scripts/tobs-blaine/installation/) for details.

**Requires:** vRP · [ox_lib](https://github.com/overextended/ox_lib) (recommended) · [ox_target](https://github.com/overextended/ox_target) (optional)

Using a different framework? See the [ESX version](https://github.com/Vega421/tobs_blaineESX).

## Credits and license

Made by Vega, based on [utkuali/Fleeca-Bank-Heists](https://github.com/utkuali/Fleeca-Bank-Heists). Licensed under [GPL-3.0](LICENSE): you can use, change and share it, as long as your version stays open source under GPL-3.0 and keeps the credits.
