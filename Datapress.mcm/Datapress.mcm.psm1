function mcm {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $false)]
    [string]
    $P,
    [Parameter(Mandatory = $false, HelpMessage="with using the -Pp parameter mc will generate the 'mcPathlog.txt' file into your current directory")]
    [string]
    $Pp
  )
  # if -Pp was not given just run mc -P
  if (!$Pp -and $P) {
    Start-Process mc.exe -ArgumentList "-P $P" -NoNewWindow -Wait
    $logPath = Get-Content $P
    Set-Location $logPath
    Remove-Item $P
  }
  # if neither -P or -Pp was given run mc without params
  elseif ((!$Pp) -and (!$P) ) {
    mc.exe
  }
  # if both parameters were provided warn the user of conflicting parameters
  elseif (($Pp) -and ($P)) {
    Write-Warning "Conflicting parameters!"
  }
  # if only -Pp was provided run mc -Pp mcLog.txt
  else {
    $currentPath = Get-Location
    $txtPath = Join-Path $currentPath $Pp
    Start-Process mc.exe -ArgumentList "-P $txtPath" -NoNewWindow -Wait
    $logPath = Get-Content $Pp
    Set-Location $logPath
    Remove-Item $txtPath
  }
}
