# Variables
$VMCount = 4  # Number of virtual machines to create
$BaseVMName = "Rancher"  # Base name for the virtual machines
$SwitchName = "Racher-switch"  # Replace with your desired Hyper-V virtual switch name
$VHDPath = "D:\hyper-v\vm_drives\rancher-" # Replace with desired path for VHD files
$VHDSpaceGB = 20  # Replace with desired size in GB
$ISOPath = "D:\ISO\ubuntu-24.04-live-server-amd64.iso"  # Replace with path to Ubuntu ISO file
$CPUCount = 4  # Replace with desired number of CPUs

# Check if the virtual switch already exists
if (Get-VMSwitch -Name $SwitchName -ErrorAction SilentlyContinue) {
    Write-Host "Virtual switch '$SwitchName' already exists."
}
else {
    # Create virtual switch
    New-VMSwitch -Name $SwitchName -NetAdapterName "Ethernet" -AllowManagementOS $true
    Write-Host "Virtual switch '$SwitchName' created."
}

for ($i = 1; $i -le $VMCount; $i++) {
    $VMIndex = $i
    $VMName = $BaseVMName + $VMIndex

    # Create new virtual hard disk
    $VHDPathWithIndex = $VHDPath + $i + ".vhdx"

    # Create new virtual machine
    New-VHD -Path $VHDPathWithIndex -Dynamic -SizeBytes (1GB * 1024 * $VHDSpaceGB)
    $VM = New-VM -Name $VMName -MemoryStartupBytes 2GB -Generation 2 -VHDPath $VHDPathWithIndex

    # Disable Secure Boot
    Set-VMFirmware -VMName $VMName -EnableSecureBoot Off

    # Set the number of CPUs for the virtual machine
    Set-VMProcessor -VMName $VMName -Count $CPUCount

    # Attach virtual machine to virtual switch
    $VirtualSwitch = Get-VMSwitch -Name $SwitchName
    Connect-VMNetworkAdapter -VMName $VMName -SwitchName $VirtualSwitch.Name

    # Set installation media
    Add-VMDvdDrive -VMName $VMName -Path $ISOPath

    # Configure boot order to boot from DVD drive
    Set-VMFirmware -VMName $VMName -FirstBootDevice (Get-VMDvdDrive -VMName $VMName)


    # Start the virtual machine
    Start-VM -VMName $VMName

    Write-Host "Virtual machine $VMName has been provisioned. You may Proceed with setting up the ubuntu OS."
}