function Publish-AllModules {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory=$true)]
    [String]
    $apiKey,
    [Parameter(Mandatory=$true)]
    [String]
    $repository
  )
  $paths = Get-ChildItem -Directory
  foreach ($path in $paths.Name) {
    if (Test-Path $path/*.psd1) {
      try {
        Publish-Module -Path .\$path\ -NuGetApiKey $apiKey -Repository $repository
      }
      catch {
        Write-Host "Skipping duplicate"
      }
    }
  }
}
