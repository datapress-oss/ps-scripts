function Remove-EmptyDirectories {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [switch]
        $Dryrun
    )

    # get your current directory's child directories as an array
    $directoryList = Get-ChildItem -Directory

    foreach ($directory in $directoryList) {
        if ((Get-ChildItem $directory | Measure-Object).Count -eq 0) {
            # if a directory contains no child item at all, that directory will be deleted
            ($Dryrun) ? (Remove-Item $directory -WhatIf) : (Remove-Item $directory)
        }
    }
    
    $completeMsg = ($Dryrun) ? "Dry-run operation has completed." : "Operation has completed."
    Write-Host $completeMsg -ForegroundColor Green
}
