$config = Get-Content -Path $($PSScriptRoot | Join-Path -ChildPath "config.json") | ConvertFrom-Json
Get-ScheduledTask -TaskPath $config.taskPath | Unregister-ScheduledTask -Confirm:$false -ErrorAction SilentlyContinue

$appDirPath = $env:APPDATA | Join-Path -ChildPath $($PSScriptRoot | Split-Path -Leaf)

powershell.exe -NoProfile -ExecutionPolicy Bypass -File $(Get-ChildItem -Path $appDirPath -Filter "*.ps1" | Select-Object -First 1).FullName

Get-Item -Path $appDirPath -ErrorAction SilentlyContinue | Remove-Item -Recurse -ErrorAction SilentlyContinue

$schedule = New-Object -ComObject Schedule.Service
$schedule.connect()
$root = $schedule.GetFolder("\")
$root.DeleteFolder($config.taskPath.TrimStart("\").TrimEnd("\"), $null)
