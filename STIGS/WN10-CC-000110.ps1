<#
.SYNOPSIS
    This PowerShell script ensures that the maximum size of the Windows Application event log is at least 32768 KB (32MB).

.NOTES
    Author          : Neenon Segura
    LinkedIn        : linkedin.com/in/neenon-segura/
    GitHub          : github.com/neenonsegura
    Date Created    : 2025-08-25
    Last Modified   : 2025-08-25
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000110

.TESTED ON
    Date(s) Tested  : 2025-08-25
    Tested By       : Neenon Segura
    Systems Tested  : Windows 10 Pro, Build 22H2
    PowerShell Ver. : 5.1.17763.6189

.USAGE
    Example syntax:
    PS C:\> .\STIG-ID-WN10-CC-000110.ps1 
#>

# WN10-CC-000110: Prevent printing over HTTP
# Registry: HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Printers
# Value: DisableHTTPPrinting (DWORD) = 1

$regPath   = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Printers"
$valueName = "DisableHTTPPrinting"
$desired   = 1

# Ensure the key exists
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# Set the value
New-ItemProperty -Path $regPath -Name $valueName -PropertyType DWord -Value $desired -Force | Out-Null

# Verify
$current = (Get-ItemProperty -Path $regPath -Name $valueName).$valueName
Write-Host "'$valueName' is set to: $current"
if ($current -eq $desired) {
    Write-Host "Compliant: Printing over HTTP is disabled."
} else {
    Write-Host "Not compliant: Expected $desired but found $current."
}

# (Optional) Refresh policies / printing subsystem
# gpupdate /force | Out-Null
# Restart-Service -Name Spooler -Force
