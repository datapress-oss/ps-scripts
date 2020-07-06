# Get the path for the terminal's settings.json
$location = Get-ChildItem C:\Users\$env:UserName\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json

# Save the content of 'settings.json' as a powershell object
$settings = Get-Content -Raw $location | ConvertFrom-Json

# print out current settings with coloring
Write-Host "This is your current color scheme: " -nonewline
Write-Host $settings.profiles.defaults.colorScheme -foreground red
Write-Host

# get all avaliable settings and print them out
$schemeList = [System.Collections.ArrayList]::new()
foreach ($scheme in $settings.schemes) {
  # cast to void to ignore the return value from the Add method 
  [void]$schemeList.Add($scheme.name)
}

# print out all avaliable options
Write-Host "These are your avaliable options:"
Write-Host
$i = 0
foreach ($item in $schemeList) {
  $i++
  Write-Host "$i. $item"
}
Write-Host

# ask user to choose an option
[byte]$choice = Read-Host 'Please choose one from the above list [example: 1]'

# update the current colorScheme value
$settings.profiles.defaults.colorScheme = $schemeList[$choice-1]

Write-Host "Updated to: $($settings.profiles.defaults.colorScheme)"

# save changed settings into settings.json
$settings | ConvertTo-Json -Depth 100 | Set-Content -Path $location

Write-Host
Write-Host
