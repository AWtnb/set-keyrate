# README

Set keyrate of Windows.

## Install / Uninstall

[install.ps1](./install.ps1) copies [set-keyrate.ps1](./set-keyrate.ps1) to `$env:AppData\Roaming\set-keyrate` and registers scheduled task to run it on startup. Default dalay is 200ms and repeat rate is 12ms.

[uninstall.ps1](./uninstall.ps1) removes all data from PC.

---

thanks: https://github.com/cocolacre/scripts/blob/master/keyrate/keyrate.ps1
