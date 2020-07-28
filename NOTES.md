# Jegyzetek

A tanultakról mini kurzus keretében előadást tartunk a PowerShell-t még nem ismerő kollégáknak.

Ennek az előadásnak az előadásvázlatát tartalmazza ez a dokumentum.

## Bevezető

- Miért választottam a PowerShell megismerésének lehetőségét a "nyári gyakorlat" keretében

## Általános áttekintő

- Mire jó a parancssor? Kik azok akik szívesen használják?
- Mi a PowerShell?
  - Ki fejleszti
  - Kinek szánják, milyen feladatok elvégzésére használható eszköz
  - Milyen platformokon érhető el, mire épül
  - Mit vált le, minek a helyére ajálják

## Windows Terminal

- Telepítés
- UWP sandbox
- Beállítások, dokumentáció, GitHub oldal
- Testreszabás
- Hogyan indítható a PowerShell
- Gyorsbillenyűk, pane-k
- Elevált módban való futtatás (sudo)

## PowerShell

### Általános áttekintés

- Dotnet Core / Framework vs PowerShell Core (Verziók)
- Profilok (Windows PowerShell vs PowerShell Core)
- PSReadLine (Argument-Completer, Tab), beállítások (EMACS, gyorsbillentyűk: ctrl+r, ctrl+u, ctrl+w)
- Környezeti változók ($history, $host, $home, $islinux, $iswindows, $lastexitcode, $null, $psversiontable. \$psdefaultparametervalues)
- CmdLet (elnevezés Verb-Noun, Get-Verb, Get-Command), külső parancsok, aliasok

### PSProvider, PSDrive

- Fájlrendszer
- Regisztációs adatbázis
- Aliasok
- Funkciók

### Modul rendszer

- Mik azok a modulok
- Hogyan / honnan telepíthetek (PSGalery, GitHub Packages)
- Hasznos modulok bemutatása: posh-git, z, Datapress.PowerShellPrograms
  - Profilba illesztés
  - starship / prompt

### Távoli elérés

- Linux vs. Windows

### Csövezés

- Mik az objektumok (Metodus, Property)
- Begin / Process / End
- Pár egysoros példa avagy mitől Power a PowerShell

```powershell
$major, $minor, $patch = (git --version|sls \d+\.\d+\.\d+).Matches.Value -split '\.'

while ($true) { Write-Host -NoNewline "`r$((Get-Date).ToString('hh:mm:ss')) $((Get-NetTCPConnection -LocalPort 8080 -ErrorAction SilentlyContinue | where { $_.State -eq 'Established'} | select -First 1) -ne $null)  "; sleep 1 }

'\\{0} has been up for {1}' -f
    $env:COMPUTERNAME,
    (Get-CimInstance Win32_OperatingSystem | Select-Object @{ Name="Uptime"; Expression={ $d = (Get-Date) - $_.LastBootUptime; '{0} day(s) {1}' -f $d.ToString('dd'), $d.ToString('hh\:mm\:ss') }}).Uptime
```

## Programozás

### Alapok

- VS Code vs. ISE
- Control Flow
- Változó nevek ($'ez is egy érvényes változónév' = 1)
- Operátorok (-join -replace -match -eq -nq -lt)
- Tömbök, hashtable szintaxis
- PSCustomObject
- Debug (Interactive Session)

### Datapress.PowerShellPrograms bemutatása

- Import-Module Datapress.PowerShellPrograms
- Remove-EmptyDirectories
- ArgumentCompleter
- Set-ColorTheme

## Zárszó

- Benyomásom a PowerShell-ről
  - Előnyök
  - Hátrányok
- Milyen volt a közös "munka", tanulás
