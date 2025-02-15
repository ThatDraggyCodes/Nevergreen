. "$PSScriptRoot\ImportFunctions.ps1"
Remove-Item "$env:temp\Nevergreen.log" -ErrorAction Ignore
Start-Transcript -Path "$env:temp\Nevergreen.log" -Force -UseMinimalHeader
Clear-Host
Write-Host "PowerShell version: $($PSVersionTable.PSVersion)"
$Apps = Find-NevergreenApp

foreach ($App in $Apps) {
    Write-Host "$App`:"
    try {
        $Result = Get-NevergreenApp $App
        $Result | Format-List
        #$Result.URI | ForEach-Object {
            #Invoke-Download $_
        #}
    }
    catch {
        Write-Error $_
    }
}
Stop-Transcript