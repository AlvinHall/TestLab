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
   Creates a new Test Lab
.DESCRIPTION
   Creates the following for a new Test Lab:
   - Folder structure
     - It will create a new folder under the Labs Root folder with the name of the Test Lab
   - Private Virtual Switch
     - It will create a new Private Virtual Switch called vSwitch-Private-[Test Lab], e.g. vSwitch-Private-SCCM
   for a new Test Lab and a new Private Virtual Switch.

   The script currently assumes the root folder for Test Labs is 'C:\Virtual Machines' and creates a new folder for the test lab, e.g. 'C:\Virtual Machines\SCCM' for the SCCM Test Lab.

   ***FEATURES TO ADD***
   - Create a Domain Controller
     - Create a new AD Forest called [TESTLAB].internal
	 - Create base OU structure
	 - Import base Security GPOs
   - Create a Windows client
     - Match the Domain level (Win8.1 for Server 2012 R2, Windows 10 for Server 2016)
   - Specify AD Domain level, e.g. Server 2012 R2, Server 2016
.EXAMPLE
   New-TestLab -Lab SCCM

   This will create a new Test Lab called SCCM under the folder C:\Virtual Machines.
.EXAMPLE
   New-TestLab -Lab SCCM -Root 'C:\Test Labs'
   
   This will create a new Test Lab called SCCM under the folder C:\Test Labs.
#>
Function New-TestLab {
	[CmdletBinding()]
	Param(
		[Parameter(Mandatory=$True,Position=0)][Alias("Lab")][String]$TestLab,
		[Parameter(Mandatory=$False,Position=0)][Alias("Root","Path")][String]$LabRoot='C:\Virtual Machines'
	)
	$TestLabRoot = "$LabRoot\$TestLab"

	#Create folder structure
	If (!(Test-Path -Path $LabRoot)) {
		Write-Verbose "Test Lab Root Folder [$LabRoot] does not exist."
		Write-Verbose "Creating Test Lab Root Folder - $LabRoot"
		Try {
			New-Item -Path $LabRoot -ItemType Directory | Out-Null
		} Catch {
			Write-Error "Unable to create folder $Path"
			Break
		}
	}

	If (!(Test-Path -Path $TestLabRoot)) {
		Write-Verbose "Creating Test Lab folder $TestLab"
		Try {
			New-Item -Path $TestLabRoot -ItemType Directory | Out-Null
		} Catch {
			Write-Error "Unable to create folder $TestLabRoot"
			Break
		}
	} Else {
		Write-Error "Test Lab $TestLab already exists"
		Break
	}
	#Create Domain Controller

	#Create Windows Client

}

<#
.Synopsis
   Creates a new VM in an existing Test Lab
.DESCRIPTION
   Creates a new Virtual Machine in an existing Test Lab

   This will create a new VM based off of an existing template or from completely new parameters. It will connect

   ***FEATURES TO ADD***
   - Create new VM based off of templates, e.g. Domain Controller (DC), Member Server (MS), Client, etc.
.EXAMPLE
   New-TestLabVM -Lab SCCM -Name SCCM

   This will create a VM called SCCM-SCCM in the SCCM Test Lab
.EXAMPLE
   New-TestLab -Lab SCCM -Root 'C:\Test Labs' -Name MAN1 -vCPU 2 -RAM 6GB -HDD @(30GB,45GB)
   
   This will create a VM called SCCM-SCCM in the SCCM Test Lab with 2 virtual CPUs, 6GB of RAM and 2 HDDs
#>
Function New-TestLabVM {
	[CmdletBinding()]
	Param(
		[Parameter(Mandatory=$True,Position=0)][Alias("Lab")][String]$TestLab,
		[Parameter(Mandatory=$False,Position=0)][Alias("Root","Path")][String]$LabRoot='C:\Virtual Machines',
		[Parameter(Mandatory=$True,Position=0)][String]$Name,
		[Parameter(Mandatory=$True,ParameterSetName='VMType',Position=0)][String]$VMType,
		[Parameter(Mandatory=$True,ParameterSetName='VMUntyped',Position=0)][String]$vCPU,
		[Parameter(Mandatory=$True,ParameterSetName='VMUntyped',Position=0)][String]$RAM,
		[Parameter(Mandatory=$True,ParameterSetName='VMUntyped',Position=0)][String]$HDD

	)
	$TestLabRoot = "$LabRoot\$TestLab"
	
	#Confirm that the Test Lab folder structure exists
	If (!($TestLabRoot)) {
		Write-Error "Test Lab $TestLab does not exist"
		Break
	}

	#Create new Virtual Machine
	Switch ($PsCmdlet.ParameterSetName) {
		'VMType' {
			#Create VM based off of a preset template
		}
		'VMUntyped' {
			#Create a new VM
		}
	}
}