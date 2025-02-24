$hostsPath = "C:\Windows\System32\drivers\etc\hosts"
$listUrl = "https://raw.githubusercontent.com/Ruddernation-Designs/Adobe-URL-Block-List/master/hosts.txt"

function AddToHosts {
    param ($hostsPath, $domains)

    $currentHosts = Get-Content -Path $hostsPath -ErrorAction Stop
    $newLines = @()

    foreach ($domain in $domains) {
        $line = "127.0.0.1 $domain"
        if ($currentHosts -notcontains $line) {
            $newLines += $line
        }
    }

    if ($newLines) {
        Add-Content -Path $hostsPath -Value $newLines -ErrorAction Stop
    }
}

$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")

if (-not $isAdmin) {
    Write-Warning "Dieses Skript muss als Administrator ausgeführt werden."
    exit 1
}

$domainsToBlock = (New-object System.net.webclient).DownloadString($listUrl).Split([System.Environment]::Newline)
AddToHosts -hostsPath $hostsPath -domains $domainsToBlock

Write-Host "Hosts-Datei erfolgreich aktualisiert."
