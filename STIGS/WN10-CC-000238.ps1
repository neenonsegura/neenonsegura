<#
.SYNOPSIS
    This PowerShell script ensures that PreventCertErrorOverrides exists and is set to 1 under the Edge policy path.

.NOTES
    Author          : Neenon Segura
    LinkedIn        : linkedin.com/in/neenon-segura/
    GitHub          : github.com/neenonsegura
    Date Created    : 2025-08-24
    Last Modified   : 2025-08-24
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000238

.TESTED ON
    Date(s) Tested  : 2025-08-24
    Tested By       : Neenon Segura
    Systems Tested  : Windows 10 Pro, Build 22H2
    PowerShell Ver. : 5.1.17763.6189

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\STIG-ID-WN10-CC-000238.ps1 
#>

# Ensure PreventCertErrorOverrides is configured for Microsoft Edge
# Registry: HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge\Internet Settings
# Value: PreventCertErrorOverrides = 1 (DWORD)

$regPath   = "HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge\Internet Settings"
$valueName = "PreventCertErrorOverrides"
$desired   = 1

# Create key if missing
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# Set value
New-ItemProperty -Path $regPath -Name $valueName -PropertyType DWord -Value $desired -Force | Out-Null

# Verify
$current = (Get-ItemProperty -Path $regPath -Name $valueName).$valueName
Write-Host "'$valueName' is set to: $current"
if ($current -eq $desired) {
    Write-Host "Compliant: PreventCertErrorOverrides is enforced."
} else {
    Write-Host "Not compliant: Expected $desired but found $current."
}
