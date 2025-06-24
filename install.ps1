$config = Get-Content -Path $($PSScriptRoot | Join-Path -ChildPath "config.json") | ConvertFrom-Json

$taskPath = $config.taskPath
if (-not $taskPath.StartsWith("\")) {
    $taskPath = "\" + $taskPath
}
if (-not $taskPath.EndsWith("\")) {
    $taskPath = $taskPath + "\"
}

$appDir = $env:APPDATA | Join-Path -ChildPath $($PSScriptRoot | Split-Path -Leaf)
if (-not (Test-Path $appDir -PathType Container)) {
    New-Item -Path $appDir -ItemType Directory > $null
}
$src = $PSScriptRoot | Join-Path -ChildPath "set-keyrate.ps1" | Copy-Item -Destination $appDir -PassThru

$delay = $config.delay
$rate = $config.rate
$command = "powershell.exe -NoProfile -ExecutionPolicy Bypass -File `"$src`" $delay $rate"

Invoke-Expression -Command $command

$action = New-ScheduledTaskAction -Execute conhost.exe -Argument "--headless $command"
$settings = New-ScheduledTaskSettingsSet -Hidden -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries

$startupTaskName = "startup"
$startupTrigger = New-ScheduledTaskTrigger -AtLogOn -User $env:USERNAME

Register-ScheduledTask -TaskName $startupTaskName `
    -TaskPath $taskPath `
    -Action $action `
    -Trigger $startupTrigger `
    -Description "Set keyrate." `
    -Settings $settings `
    -Force
