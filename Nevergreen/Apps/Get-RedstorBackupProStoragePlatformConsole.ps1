$UserAgents = @(
    $Null
    # User agent from [Microsoft.PowerShell.Commands.PSUserAgent]::Chrome in PowerShell 7
    'Mozilla/5.0 (Windows NT 10.0; Microsoft Windows 10.0.22631; en-GB) AppleWebKit/534.6 (KHTML, like Gecko) Chrome/7.0.500.0 Safari/534.6'
)
$DownloadPageURL = $Null

foreach ($UserAgent in $UserAgents) {
    $GetLinkExtraParams = @{}
    if ($UserAgent) {
        $GetLinkExtraParams['UserAgent'] = $UserAgent
    }
    try {
        $DownloadPageURL = Get-Link `
            @GetLinkExtraParams `
            -Uri 'https://support.redstor.com/hc/en-gb/sections/200458081-Downloads' `
            -MatchProperty href `
            -Pattern 'Latest-downloads' `
            -PrefixDomain `
            -ErrorAction Stop
    } catch {
        continue
    }
    break
}

if (-not $DownloadPageURL) {
    Write-Error 'Could not connect to Redstor download page.'
    return
}

$URL32 = Get-Link `
    @GetLinkExtraParams `
    -Uri $DownloadPageURL `
    -MatchProperty href `
    -Pattern 'RedstorBackupPro-SP-Console'

$Version = $URL32 | Get-Version -Pattern '((?:\d+\.)+\d+)\.exe$'

New-NevergreenApp -Name 'Redstor Backup Pro Storage Platform Console' -Version $Version -Uri $URL32 -Architecture 'x86' -Type 'Exe'