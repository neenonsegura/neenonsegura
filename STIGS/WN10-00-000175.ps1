<#
.SYNOPSIS
    This PowerShell script ensures that "Secondary Logon" service is disabled which prevents “Run as different user” scenarios and services/apps that rely on it.

.NOTES
    Author          : Neenon Segura
    LinkedIn        : linkedin.com/in/neenon-segura/
    GitHub          : github.com/neenonsegura
    Date Created    : 2025-08-25
    Last Modified   : 2025-08-25
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-00-000175

.TESTED ON
    Date(s) Tested  : 2025-08-25
    Tested By       : Neenon Segura
    Systems Tested  : Windows 10 Pro, Build 22H2
    PowerShell Ver. : 5.1.17763.6189

.USAGE
    Example syntax:
    PS C:\> .\STIG-ID-WN10-00-000175.ps1 
#>

# Validation script for WN10-00-000175
# Secondary Logon service must be Disabled and not Running

$svcName = 'seclogon'

try {
    $svc    = Get-Service -Name $svcName -ErrorAction Stop
    $svcCim = Get-CimInstance -ClassName Win32_Service -Filter "Name='$svcName'"

    $status   = $svc.Status         # Running/Stopped
    $startMode = $svcCim.StartMode  # Automatic/Manual/Disabled

    Write-Host "Secondary Logon service status:"
    Write-Host "  Startup Type : $startMode"
    Write-Host "  Status       : $status"

    if ($startMode -eq 'Disabled' -and $status -eq 'Stopped') {
        Write-Host "Compliant: Startup Type is Disabled and Status is Stopped."
    }
    else {
        Write-Warning "Finding: Expected Disabled + Stopped, found Startup Type=$startMode, Status=$status"
    }
}
catch {
    Write-Error "Unable to check Secondary Logon service: $($_.Exception.Message)"
}
