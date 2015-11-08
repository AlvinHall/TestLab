<#
.Synopsis
   Starts the SCCM Test Lab
.DESCRIPTION
   Starts the Virtual Machines DC1 and SCCM
.EXAMPLE
   Start-TestLab
#>
Function Start-TestLab {
	[CmdletBinding()]
	Param()

	$TestLabVMs = @('DC1','SCCM')
	ForEach ($TestLabVM in $TestLabVMs) {
		$VM = Get-VM -Name $TestLabVM
		If ($VM.State -ne 'Running') {
			Write-Host "Virtual Machine $TestLabVM isn't running. Starting Virtual Machine..."
			Start-VM -VM $VM
			Start-Sleep -Seconds 30
		} Else {
			Write-Host "Virtual Machine $TestLabVM is running"
		}
	}
}

<#
.Synopsis
   Exports Test Lab to external HDD
.DESCRIPTION
   Exports SCCM Test Lab to external HDD. This is used as either a backup or an alternative to managing checkpoints on all VMs, e.g. Export for a point in time with capability to restore
.EXAMPLE
   Export-TestLab
.EXAMPLE
   Another example of how to use this cmdlet
#>
Function Export-TestLab {
	[CmdletBinding()]
	Param()

	$TestLabVMs = @('DC1','SCCM','IPAM')
	$ExportFolder = "F:\Framework WinX\VM Exports"

	If (!(Test-Path $ExportFolder)) {
		Write-host "Export folder is not present. Creating folder"
		New-Item -ItemType Directory -Path $ExportFolder | Out-Null
	}

	ForEach ($TestLabVM in $TestLabVMs) {
		$VM = Get-VM -Name $TestLabVM
		If ($VM.State -ne 'Running') {
			Write-Host "VM $TestLabVM is not running. Exporting VM..."
			Export-VM -VM $VM -Path $ExportFolder
		} Else {
			Write-Host "Virtual Machine $TestLabVM is running"
			Export-VM -VM $VM -Path $ExportFolder -CaptureLiveState
		}
	}
}