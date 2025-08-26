<#
.SYNOPSIS
    This PowerShell script ensures that only the Administrators and Users groups have rights to log on interactively to a system.

.NOTES
    Author          : Neenon Segura
    LinkedIn        : linkedin.com/in/neenon-segura/
    GitHub          : github.com/neenonsegura
    Date Created    : 2025-08-24
    Last Modified   : 2025-08-24
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-UR-000025

.TESTED ON
    Date(s) Tested  : 2025-08-24
    Tested By       : Neenon Segura
    Systems Tested  : Windows 10 Pro, Build 22H2
    PowerShell Ver. : 5.1.17763.6189

.USAGE
    Example syntax:
    PS C:\> .\STIG-ID-WN10-UR-000025.ps1 
#>

# WN10-UR-000025: Restrict "Allow log on locally" (SeInteractiveLogonRight)
# Must only be Administrators and Users groups.

# Define the SID-based list (these are well-known SIDs for local groups)
# S-1-5-32-544 = Administrators
# S-1-5-32-545 = Users
$allowedSIDs = "*S-1-5-32-544,*S-1-5-32-545"

# Step 1: Export current security policy
$tempInf = "$env:TEMP\secpol.inf"
$tempSdb = "$env:TEMP\secpol.sdb"
secedit /export /cfg $tempInf /quiet

# Step 2: Read in the INF, replace the SeInteractiveLogonRight line
$lines = Get-Content $tempInf

if ($lines -match '^SeInteractiveLogonRight') {
    # Replace existing entry
    $lines = $lines -replace '^SeInteractiveLogonRight.*', "SeInteractiveLogonRight = $allowedSIDs"
} else {
    # Add it if missing
    $lines += "SeInteractiveLogonRight = $allowedSIDs"
}

# Save updated INF
Set-Content -Path $tempInf -Value $lines -Encoding Unicode

# Step 3: Apply the new policy
secedit /configure /db $tempSdb /cfg $tempInf /areas USER_RIGHTS /quiet

# Step 4: Cleanup
Remove-Item $tempSdb -Force
Remove-Item $tempInf -Force

Write-Host "Configured 'Allow log on locally' to only Administrators and Users groups."
