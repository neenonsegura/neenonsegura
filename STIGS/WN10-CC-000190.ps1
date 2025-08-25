<#
.SYNOPSIS
    This PowerShell script ensures that AutoRun/AutoPlay has been disabled for all drive types.

.NOTES
    Author          : Neenon Segura
    LinkedIn        : linkedin.com/in/neenon-segura/
    GitHub          : github.com/neenonsegura
    Date Created    : 2025-08-25
    Last Modified   : 2025-08-25
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000190

.TESTED ON
    Date(s) Tested  : 2025-08-25
    Tested By       : Neenon Segura
    Systems Tested  : Windows 10 Pro, Build 22H2
    PowerShell Ver. : 5.1.17763.6189

.USAGE
    Example syntax:
    PS C:\> .\STIG-ID-WN10-AU-000500.ps1 
#>

# WN10-CC-000190: Disable Autoplay for all drives
# Registry: HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer
# Value: NoDriveTypeAutoRun = 0xFF (255)

$regPath   = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
$valueName = "NoDriveTypeAutoRun"
$desired   = 0xFF  # 255 decimal

# Ensure registry key exists
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# Set the DWORD value
New-ItemProperty -Path $regPath -Name $valueName -Value $desired -PropertyType DWord -Force | Out-Null

# Verify
$current = (Get-ItemProperty -Path $regPath -Name $valueName).$valueName
Write-Host "'$valueName' is set to: $current (Decimal)" 
Write-Host "Hex: 0x$("{0:X}" -f $current)"

if ($current -eq $desired) {
    Write-Host "Compliant: Autoplay is disabled for all drives."
} else {
    Write-Host "Not compliant: Expected $desired but found $current."
}
