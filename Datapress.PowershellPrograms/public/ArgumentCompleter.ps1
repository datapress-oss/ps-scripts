#region routefinder ArgumentCompleter
New-Variable -Name IsLoaded -Value $false -Scope script -Visibility Private
function Remove-Diacritics {
    param ([String]$sToModify = [String]::Empty)

    foreach ($s in $sToModify) { # Param may be a string or a list of strings
        if ($sToModify -eq $null) { return [string]::Empty }

        $sNormalized = $sToModify.Normalize("FormD")

        foreach ($c in [Char[]]$sNormalized) {
            $uCategory = [System.Globalization.CharUnicodeInfo]::GetUnicodeCategory($c)
            if ($uCategory -ne "NonSpacingMark") { $res += $c }
        }

        return $res
    }
}

class Station {
    [string]$Name
    [string]$NameWithoutAccents
    [int]$Id

    Station([string]$Name, [int]$Id) {
        $this.Name = $Name
        $this.Id = $Id
        $this.NameWithoutAccents = Remove-Diacritics $Name
    }

    [string] ToString() {
        return '$Name, $Id'
    }
}

function Get-CommandName {
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $AstString
    )
    # convert the input line into a list
    [System.Collections.ArrayList]$AstStringList = $AstString -split " "
    $currentIndex = $AstStringList.Count - 1

    #region logic to decide where to provide arguments from
    if ($AstStringList.Count -lt 3) {
      # provide arguments based on the program's name to complete commands
        [string]$ParamKey = $AstStringList[0]
    }
    elseif ($AstStringList[$currentIndex] -match "^-.*") {
      # provide arguments based on the current command's name to complete parameters
        [string]$ParamKey = $AstStringList[1]
    }
    else {
      # provide arguments based on the current parameter's name to complete parameter values
        [string]$ParamKey = $AstStringList[$currentIndex - 1]
    }
    #endregion

    #region return the raw parameter name
    if ($ParamKey -match "^-[^-]") {
        # remove the first "-" character from the parameter name
        $ParamKey = $ParamKey -replace '(.*?)-(.*)', '$1$2'
        return $ParamKey
    }
    elseif ($ParamKey -like "--*") {
        # remove the first "--" character from the parameter name
        $ParamKey = $ParamKey -replace '(.*?)--(.*)', '$1$2'
        return $ParamKey
    }
    else {
        return $ParamKey
    }
    #endregion
}
$stations = [System.Collections.ArrayList]@()
$ParameterHash = @{
    routefinder = @("findroute", "setroute", "deleteroute")
    findroute = @("-DepartureStation", "-DestinationStation");
}
Register-ArgumentCompleter -Native -CommandName @("routefinder") -ScriptBlock {
    param ($wordToComplete, $commandAst, $cursorPosition)
    try {
        if ($script:IsLoaded -eq $false) {
            # import database here and set global scope list so it'll only load once
            Import-Csv -Path "$PSScriptRoot\s_station_202007201438.csv" -Delimiter ',' | ForEach-Object { $null = $stations.Add([Station]::new($_.Name, $_.Id)) }
            $script:IsLoaded = $true
        }
        # finds the last command in the input line
        $ParamKey = Get-CommandName -AstString $commandAst.ToString()
        if ($ParamKey -match "De.*.Station") {
            # in case of Departure and Destination station parameters, register arguments from the "$stations" list
            # convert arguments to words without accents
            [string]$wordWithoutAccentsToComplete = Remove-Diacritics $wordToComplete
            if ($wordWithoutAccentsToComplete -match '_') {
                # handle words with spaces
                $wordWithoutAccentsToComplete = $wordWithoutAccentsToComplete -replace '_', ' '
                $possibleValues = $stations | Where-Object {$_.NameWithoutAccents -like "*$wordWithoutAccentsToComplete*"}
            }
            else {
                $possibleValues = $stations | Where-Object {$_.NameWithoutAccents -like "$wordWithoutAccentsToComplete*"}
            }
            $possibleValues | ForEach-Object {
                [System.Management.Automation.CompletionResult]::new($_.Name, $_.Name, 'Text', $_.Name)
            }
        }
        else {
            # register arguments from the "$ParamKey" hashtable
            $possibleValues = $ParameterHash.$ParamKey | Where-Object {$_ -like "$wordToComplete*"}
            $possibleValues | ForEach-Object {
                [System.Management.Automation.CompletionResult]::new($_, $_, 'Text', $_)
            }
        }
    }
    catch {
        Set-Content -Path "$env:TMP\ArgumentCompleterErrorlog.txt" -Value $_
    }

}
#endregion