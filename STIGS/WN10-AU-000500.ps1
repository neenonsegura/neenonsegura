<#
.SYNOPSIS
    This PowerShell script ensures that the maximum size of the Windows Application event log is at least 32768 KB (32MB).

.NOTES
    Author          : Neenon Segura
    LinkedIn        : linkedin.com/in/neenon-segura/
    GitHub          : github.com/neenonsegura
    Date Created    : 2025-08-24
    Last Modified   : 2025-08-24
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-AU-000500

.TESTED ON
    Date(s) Tested  : 2025-08-24
    Tested By       : Neenon Segura
    Systems Tested  : Windows 10 Pro, Build 22H2
    PowerShell Ver. : 5.1.17763.6189

.USAGE
    Example syntax:
    PS C:\> .\STIG-ID-WN10-AU-000500.ps1 
#>

# Define the registry path and value
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\Application"
$valueName = "MaxSize"
$valueData = 0x00008000  # 32768 in decimal

# Create the registry key if it doesn’t exist
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# Set the DWORD value
New-ItemProperty -Path $regPath -Name $valueName -Value $valueData -PropertyType DWord -Force | Out-Null

# Confirm the change
Get-ItemProperty -Path $regPath | Select-Object $valueName
