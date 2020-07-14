function Remove-EmptyDirectories {
    <#
    .SYNOPSIS
    
    Finds empty directories and deletes them.
    
    .DESCRIPTION
    
    Finds empty directories and deletes them.
    If there is a directory with only hidden item/items in it, you'll be prompted to confirm the deletion!
    Your current directory "pwd" has to be the parent directory of the directory/s you want to be deleted.
    
    .PARAMETER Dryrun
    This parameter does not need a value. If provided, the deletion will be simulated with verbose output, but no actual changes will happen.
    
    .INPUTS
    
    None. You cannot pipe objects to Add-Extension.
    
    .EXAMPLE
    
    PS> Remove-EmptyDirectories
    Operation has completed!
    
    .EXAMPLE
    
    PS> Remove-EmptyDirectories -Dryrun
    What if: Performing the operation "Remove Directory" on target "C:\Users\username\ParentDir\child1".
    What if: Performing the operation "Remove Directory" on target "C:\Users\username\ParentDir\child2".
    What if: Performing the operation "Remove Directory" on target "C:\Users\username\ParentDir\child3".
    Dry-run operation has completed.
    
    #>
    
        [CmdletBinding()]
        param (
            [Parameter(Mandatory = $false)]
            [switch]
            $Dryrun,
            [Parameter(Mandatory = $false)]
            [string]
            $Path
        )
    
        if ($Path) {
            $RootPath = $Path
        }
        else {
            $RootPath = Get-Location
        }

        # get every directory recursively
        $directoryList = Get-ChildItem -LiteralPath $RootPath -Force -Recurse

        # reverse the dir list in order to start from the deepest level
        [array]::Reverse($directoryList)

        foreach ($directory in $directoryList) {
            if ((Get-ChildItem $directory | Measure-Object).Count -eq 0) {
                # if a directory contains no child item at all, that directory will be deleted
                ($Dryrun) ? (Remove-Item $directory -Recurse -WhatIf) : (Remove-Item $directory -Recurse -Verbose)
            }
        }
    
        $completeMsg = ($Dryrun) ? "Dry-run operation has completed." : "Operation has completed."
        Write-Host $completeMsg -ForegroundColor Green
}
