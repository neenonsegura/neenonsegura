<#
.SYNOPSIS
    This PowerShell script ensures that the Machine inactivity limit is 15 minutes (900 sec) or less.

.NOTES
    Author          : Neenon Segura
    LinkedIn        : linkedin.com/in/neenon-segura/
    GitHub          : github.com/neenonsegura
    Date Created    : 2025-08-25
    Last Modified   : 2025-08-25
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-SO-000070

.TESTED ON
    Date(s) Tested  : 2025-08-25
    Tested By       : Neenon Segura
    Systems Tested  : Windows 10 Pro, Build 22H2
    PowerShell Ver. : 5.1.17763.6189

.USAGE
    Example syntax:
    PS C:\> .\STIG-ID-WN10-SO-000070.ps1 
#>

# WN10-SO-000070 — Machine inactivity limit must be 15 minutes (900 sec) or less
# Registry: HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System
# Value: InactivityTimeoutSecs (DWORD) = 900

$regPath   = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$valueName = "InactivityTimeoutSecs"
$desired   = 900   # 15 minutes in seconds

# Ensure key exists
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# Get current value if exists
$current = (Get-ItemProperty -Path $regPath -Name $valueName -ErrorAction SilentlyContinue).$valueName

# Enforce only if missing, 0, or greater than desired
if (-not $current -or $current -eq 0 -or $current -gt $desired) {
    New-ItemProperty -Path $regPath -Name $valueName -PropertyType DWord -Value $desired -Force | Out-Null
    $current = $desired
}

# Verify
Write-Host "'$valueName' is set to: $current second(s)"
if ($current -gt 0 -and $current -le $desired) {
    Write-Host "Compliant: Inactivity timeout is $current sec (<= $desired)."
} else {
    Write-Warning "Not compliant: Expected <= $desired and not 0, found $current."
}
