<#
.SYNOPSIS
    This PowerShell script ensures that insecure guest logons are disabled.

.NOTES
    Author          : Neenon Segura
    LinkedIn        : linkedin.com/in/neenon-segura/
    GitHub          : github.com/neenonsegura
    Date Created    : 2025-08-24
    Last Modified   : 2025-08-24
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000040

.TESTED ON
    Date(s) Tested  : 2025-08-24
    Tested By       : Neenon Segura
    Systems Tested  : Windows 10 Pro, Build 22H2
    PowerShell Ver. : 5.1.17763.6189

.USAGE
    Example syntax:
    PS C:\> .\STIG-ID-WN10-CC-000040.ps1 
#>

# WN10-CC-000040: Disable insecure SMB guest logons
# Registry path: HKLM\SOFTWARE\Policies\Microsoft\Windows\LanmanWorkstation
# Value: AllowInsecureGuestAuth = 0

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\LanmanWorkstation"
$valueName = "AllowInsecureGuestAuth"
$desiredValue = 0

# Ensure the registry key exists
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# Set the value to Disabled (0)
Set-ItemProperty -Path $regPath -Name $valueName -Value $desiredValue -Type DWord -Force

# Verify
$current = Get-ItemProperty -Path $regPath | Select-Object -ExpandProperty $valueName
Write-Host "'Enable insecure guest logons' is set to:" $current
if ($current -eq 0) {
    Write-Host "Compliant: Insecure SMB guest logons are disabled."
} else {
    Write-Host "Not compliant: Insecure SMB guest logons are still enabled."
}
