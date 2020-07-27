function Remove-EmptyDirectories {
    <#
    .SYNOPSIS

    Finds empty directories and deletes them.

    .DESCRIPTION

    Finds empty directories and deletes them.
    If there is a directory with only hidden item/items in it, you'll be prompted to confirm the deletion!
    If -Path parameter is not provided, then your current directory "pwd" has to be the parent directory of the directory/s you want to be deleted.

    .PARAMETER Dryrun
    This parameter does not need a value. If provided, the deletion will be simulated with verbose output, but no actual changes will happen.

    .PARAMETER Path
    Provide the absolute path of the parent directory of the child directory/s that you want to be deleted.

    .EXAMPLE

    PS> Remove-EmptyDirectories
    Operation has completed!

    .EXAMPLE

    ParentDir> Remove-EmptyDirectories -Dryrun
    What if: Performing the operation "Remove Directory" on target "C:\Users\username\ParentDir\child1".
    What if: Performing the operation "Remove Directory" on target "C:\Users\username\ParentDir\child2".
    What if: Performing the operation "Remove Directory" on target "C:\Users\username\ParentDir\child3".
    Dry-run operation has completed.

    .EXAMPLE

    PS> Remove-EmptyDirectories -Path C:\Users\username\ParentDir
    VERBOSE: Performing the operation "Remove Directory" on target "C:\Users\username\ParentDir\child1".
    VERBOSE: Performing the operation "Remove Directory" on target "C:\Users\username\ParentDir\child2".
    VERBOSE: Performing the operation "Remove Directory" on target "C:\Users\username\ParentDir\child3".
    Dry-run operation has completed.

    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [switch]
        $Dryrun,
        [Parameter(Mandatory = $false)]
        [string]
        $Path,
        [Parameter(ValueFromPipeline)]
        $pipelinePath
    )

    Begin {
        $position = $myinvocation.PipelinePosition
        Write-Host "Pipeline position ${position}: Start"
    }
    Process {
        if ($Path) {
            $RootPath = $Path
        }
        elseif ($pipelinePath) {
            $RootPath = $pipelinePath
        }
        else {
            $RootPath = Get-Location
        }

        # get every directory recursively
        $directoryList = Get-ChildItem -LiteralPath $RootPath -Directory -Force -Recurse

        # reverse the dir list in order to start from the deepest level
        [array]::Reverse($directoryList)

        foreach ($directory in $directoryList) {
            if ((Get-ChildItem $directory | Measure-Object).Count -eq 0) {
                # if a directory contains no child item at all, that directory will be deleted
                if ($Dryrun) {
                    # run in dry-run mode
                    Remove-Item $directory -Recurse -WhatIf
                }
                else {
                    Remove-Item $directory -Recurse -Verbose
                }
            }
        }
    }
    End {
        if ($Dryrun) {
            $completeMsg = "Dry-run operation has completed."
        }
        else {
            $completeMsg = "Operation has completed."
        }
        Write-Host $completeMsg -ForegroundColor Green
    }
}
