function mcm {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $false)]
    [string]
    $P,
    [Parameter(Mandatory = $false, HelpMessage = "with using the -Pp parameter mc will generate the 'mcPathlog.txt' file into your current directory")]
    [string]
    $Pp
  )
  
  if (!$Pp -and $P) {
    # if -Pp was not given just run mc -P
    Start-Process mc.exe -ArgumentList "-P $P" -NoNewWindow -Wait
    $logPath = Get-Content $P
    Set-Location $logPath
    Remove-Item $P
  }
  elseif ((!$Pp) -and (!$P) ) {
    # if neither -P or -Pp was given run mc without params
    mc.exe
  }
  elseif (($Pp) -and ($P)) {
    # if both parameters were provided warn the user of conflicting parameters
    Write-Warning "Conflicting parameters!"
  }
  else {
    # if only -Pp was provided run mc -Pp mcLog.txt
    $currentPath = Get-Location
    $txtPath = Join-Path $currentPath $Pp
    Start-Process mc.exe -ArgumentList "-P $txtPath" -NoNewWindow -Wait
    $logPath = Get-Content $Pp
    Set-Location $logPath
    Remove-Item $txtPath
  }
}
