function Remove-EmptyDirectories {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [switch]
        $Dryrun
    )

    # get your current directory's child directories as an array
    $directoryList = Get-ChildItem -Directory

    if ($Dryrun) {
    # check if dryrun true or not, if so the code will run with the -WhatIf param to simulate the process
        foreach ($directory in $directoryList) {
            if ((Get-ChildItem $directory | Measure-Object).Count -eq 0) {
                # if a directory contains no child item at all, that directory will be deleted
                Remove-Item $directory -WhatIf
            }
        }
        Write-Host "Dry-run operation has completed." -ForegroundColor Green
    }
    else {
        foreach ($directory in $directoryList) {
            if ((Get-ChildItem $directory | Measure-Object).Count -eq 0) {
                # if a directory contains no child item at all, that directory will be deleted
                Remove-Item $directory
            }
        }
        Write-Host "Operation has completed." -ForegroundColor Green
    }
}