<#
.SYNOPSIS
    This PowerShell script ensures that WDigest is disabled by being explicitly set to 0.

.NOTES
    Author          : Neenon Segura
    LinkedIn        : linkedin.com/in/neenon-segura/
    GitHub          : github.com/neenonsegura
    Date Created    : 2025-08-25
    Last Modified   : 2025-08-25
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000038 

.TESTED ON
    Date(s) Tested  : 2025-08-25
    Tested By       : Neenon Segura
    Systems Tested  : Windows 10 Pro, Build 22H2
    PowerShell Ver. : 5.1.17763.6189

.USAGE
    Example syntax:
    PS C:\> .\STIG-ID-WN10-CC-000038.ps1 
#>

# WN10-CC-000038 — WDigest Authentication must be disabled
# HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\Wdigest
# UseLogonCredential (DWORD) = 0

$regPath   = "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\Wdigest"
$valueName = "UseLogonCredential"
$desired   = 0

# Ensure the key exists
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# Set the DWORD (explicitly disable)
New-ItemProperty -Path $regPath -Name $valueName -PropertyType DWord -Value $desired -Force | Out-Null

# Verify
$current = (Get-ItemProperty -Path $regPath -Name $valueName).$valueName
Write-Host "'$valueName' is set to: $current (expected $desired)"
if ($current -eq $desired) {
    Write-Host "Compliant: WDigest interactive logon credentials are disabled."
} else {
    Write-Warning "Not compliant: Expected $desired but found $current."
}

# NOTE: Changes to WDigest/LSASS typically require a reboot to be fully effective.
# Consider rebooting, or ensure a maintenance window is available.
