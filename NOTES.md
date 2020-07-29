# Jegyzetek

A tanultakról mini kurzus keretében előadást tartunk a PowerShell-t még nem ismerő kollégáknak.

Ennek az előadásnak az előadásvázlatát tartalmazza ez a dokumentum.

## Bevezető

- Miért választottam a PowerShell megismerésének lehetőségét a "nyári gyakorlat" keretében

## Általános áttekintő

- Mi a PowerShell?
  - Ki fejleszti
  - Milyen platformokon érhető el, mire épül
  - Mit vált le, minek a helyére ajálják

## Windows Terminal

- Telepítés
- Gyorsbillenyűk, pane-k

## PowerShell

### Általános áttekintés

- Dotnet Core / Framework vs PowerShell Core (Verziók)
- REPL funkciók (1+1, 1mb, $a, $b = $b, $a)
- Profilok (Windows PowerShell vs PowerShell Core)
- Help rendszer
- PSReadLine (Argument-Completer, Tab), beállítások (EMACS, gyorsbillentyűk: ctrl+r, ctrl+u, ctrl+w)
- Környezeti változók ($history, $islinux, $iswindows, $null, $psversiontable, $profile)
- CmdLet (elnevezés Verb-Noun, Get-Verb, Get-Command), külső parancsok, aliasok
- Beépített biztonsági mechanizmus (kód aláírás, ExecutionPolicy)

### PSProvider, PSDrive

- Fájlrendszer
- Regisztációs adatbázis
- Aliasok
- Funkciók

### Modul rendszer

- Mik azok a modulok
- Hogyan / honnan telepíthetek (PSGalery, GitHub Packages)
- Hasznos modulok bemutatása: posh-git
  - Profilba illesztés
  - starship / prompt
- fájl kiterjesztések ps1, psd1, psm1
- c# irt modulok: dotnet new psmodule


### Távoli elérés

- Linux vs. Windows

### Csövezés

- Mik az objektumok (Metodus, Property, Get-Member)
- Begin / Process / End
- Pár egysoros példa avagy mitől Power a PowerShell: git, hány napja élek

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
- Control Flow (switch($a, $b), range 1..2)
- Változó nevek ($'ez is egy érvényes változónév' = 1, 0x12 0b101010 '{0:X2}' -f 12) scope-ok
- Operátorok (-join -replace -match -eq -nq -lt, -f stb case insensitive)
- String interpolation
- Tömbök (indexelés), hashtable szintaxis
- PSCustomObject

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
