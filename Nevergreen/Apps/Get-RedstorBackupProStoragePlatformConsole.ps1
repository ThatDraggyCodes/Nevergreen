$UserAgents = @(
    $Null,  # No user agent
    # User agent for Edge, taken from the Get-Link example.
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36 Edge/12.246',
    # Chrome 123.0, Windows
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.3',
    # Edge 123.0, Windows
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36 Edg/123.0.0.',
    # Opera 108.0, Windows
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36 OPR/108.0.0.'
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
    Write-Error 'Could not convince the redstor website to skip the challange.'
}

$URL32 = Get-Link `
    @GetLinkExtraParams `
    -Uri $DownloadPageURL `
    -MatchProperty href `
    -Pattern 'RedstorBackupPro-SP-Console'

$Version = $URL32 | Get-Version -Pattern '((?:\d+\.)+\d+)\.exe$'

New-NevergreenApp -Name 'Redstor Backup Pro Storage Platform Console' -Version $Version -Uri $URL32 -Architecture 'x86' -Type 'Exe'
