<#
.SYNOPSIS
    This PowerShell script ensures that the Edge browser password manager is disabled.

.NOTES
    Author          : Neenon Segura
    LinkedIn        : linkedin.com/in/neenon-segura/
    GitHub          : github.com/neenonsegura
    Date Created    : 2025-08-25
    Last Modified   : 2025-08-25
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000245

.TESTED ON
    Date(s) Tested  : 2025-08-25
    Tested By       : Neenon Segura
    Systems Tested  : Windows 10 Pro, Build 22H2
    PowerShell Ver. : 5.1.17763.6189

.USAGE
    Example syntax:
    PS C:\> .\STIG-ID-WN10-CC-000245.ps1 
#>

# WN10-CC-000245 — Disable Edge password manager (Legacy EdgeHTML)
# Registry: HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge\Main
# Value: "FormSuggest Passwords" (REG_SZ) = "no"

$regPath   = "HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge\Main"
$valueName = "FormSuggest Passwords"
$desired   = "no"

# Ensure the key exists
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# Set the value as REG_SZ
New-ItemProperty -Path $regPath -Name $valueName -PropertyType String -Value $desired -Force | Out-Null

# Verify
$current = (Get-ItemProperty -Path $regPath -Name $valueName)."$valueName"
Write-Host "'$valueName' is set to: '$current'"
if ($current -eq $desired) {
    Write-Host "Compliant: Edge password manager (legacy) is disabled."
} else {
    Write-Warning "Not compliant: Expected '$desired' but found '$current'."
}
