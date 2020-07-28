# Powershell szkriptek

Powershell szkriptek gyűjteménye a Data-Press Kft. fejlesztési és üzemeltetési feladatainak könnyítésére.

## Tab-os commandlet kiegészítés

### Feladatok

- [ ] [automator]
- [ ] GitHub Wiki
- [ ] Modul rendszer (ps1, psm1, psd1)


## Linkek

### Referencia dokumentációk

- [tutorialspoint]
- [powershellkonyv]

### Szkripgyűjtemények

### Videók

### Blogok

[tutorialspoint]: https://www.tutorialspoint.com/powershell/index.htm
[powershellkonyv]: http://www.powershellkonyv.hu/
[automator]: https://adamtheautomator.com/powershell-parameters-argumentcompleter/



### Emlékeztetők

```powershell
// sdfd
Update-Help
sudo Update-Help -Force
Get-Help about_Updatable_Help
Get-Help *
Get-Help -Category Cmdlet
Get-Command help -Syntax
Get-Command Get-*Firewall* -Module NetSecurity

Get-Verb

Get-Alias dir
Get-Alias -Definition Get-ChildItem
Get-Help about_CommonParameters

// pipelinebol fogadhatja-e
(Get-Command Stop-Process).Parameters.InputObject.Attributes

Get-Help Stop-Process -Parameter InputObject

Clear-RecycleBin -Confirm:$false

$WhatIfPreference = $true
Get-PSProvider
Get-Help -Name FileSystem -Category Provider
Get-Help -Name Certificate -Category Provider

Get-PSDrive
New-PSDrive HKU -PSProvider Registry -Root HKEY_USERS

// Splatting
$getProcess = @{
    Name = 'explorer'
}
Get-Process @getProcess
& 'Get-Process' @getProcess

$newTaskAction = @{
    Execute = 'pwsh.exe'
    Argument = 'Write-Host "hello world"'
}
$newTaskTrigger = @{
    Daily = $true
    At    = '00:00:00'
}
$registerTask = @{
    TaskName    = 'TaskName'
    Action      = New-ScheduledTaskAction @newTaskAction
    Trigger     = New-ScheduledTaskTrigger @newTaskTrigger
    RunLevel    = 'Limited'
    Description = 'Splatting is easy to read'
}
Register-ScheduledTask @registerTask

# functions
Get-Help about_Requires
Get-Help about_Comment_Based_Help
```

### Peldak

```powershell
$major, $minor, $patch = (git --version|sls \d+\.\d+\.\d+).Matches.Value -split '\.'

while ($true) { Write-Host -NoNewline "`r$((Get-Date).ToString('hh:mm:ss')) $((Get-NetTCPConnection -LocalPort 8080 -ErrorAction SilentlyContinue | where { $_.State -eq 'Established'} | select -First 1) -ne $null)  "; sleep 1 }

'\\{0} has been up for {1}' -f 
    $env:COMPUTERNAME,
    (Get-CimInstance Win32_OperatingSystem | Select-Object @{ Name="Uptime"; Expression={ $d = (Get-Date) - $_.LastBootUptime; '{0} day(s) {1}' -f $d.ToString('dd'), $d.ToString('hh\:mm\:ss') }}).Uptime

remove-emptydirectories tudjon pipelinebol mukodni, require az elejere
```
