#Get public and private function definition files.
$Public  = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue )
$Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue )
Set-Variable -Name Public -Scope script -Visibility Private
Set-Variable -Name Private -Scope script -Visibility Private

#Dot source the files
Foreach($import in @($Public + $Private))
{
    Try
    {
        . $import.fullname
        Write-Host $import.fullname
    }
    Catch
    {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}

Export-ModuleMember -Function $Public.Basename
