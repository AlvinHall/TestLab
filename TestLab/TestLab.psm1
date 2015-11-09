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

<#
.Synopsis
   Creates the folder structure for a new Test Lab
.DESCRIPTION
   Creates the folder structure for a new Test Lab. This is to keep the storage for Test Labs in the same location and make it easy to keep them organised.

   The script currently assumes the root folder for Test Labs is 'C:\Virtual Machines' and creates a new folder for the test lab, e.g. 'C:\Virtual Machines\SCCM' for the SCCM Test Lab.

   ***FEATURES TO ADD***
   - Create a Domain Controller which has a scripted build to create a new AD Forest called [TESTLAB].internal.
   - Create a Windows client
   - Specify AD Domain level, e.g. Server 2012, Server 2012 R2, Server 2016
.EXAMPLE
   New-TestLab -Lab SCCM
.EXAMPLE
   New-TestLab -Lab SCCM -Root 'C:\Virtual Machines'
#>
Function New-TestLab {
	[CmdletBinding()]
	Param(
		[Parameter(Mandatory=$True,Position=0)][String]$Lab,
		[Parameter(Mandatory=$False,Position=0)][String]$Path='C:\Virtual Machines'
	)
	$TestLabRoot = "$Path\$Lab"

	#Create folder structure
	If (!(Test-Path -Path $Path)) {
		Write-Verbose "Test Lab Root Folder [$Path] does not exist."
		Write-Verbose "Creating Test Lab Root Folder - $Path"
		New-Item -Path $Path -ItemType Directory
	}

	If (!(Test-Path -Path $TestLabRoot)) {
		New-Item -Path $TestLabRoot -ItemType Directory
	} Else {
		Write-Error "Test Lab $Lab already exists"
		Break
	}
	#Create Domain Controller

	#Create Windows Client

}