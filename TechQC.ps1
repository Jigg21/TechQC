
#Confirms Windows Activation or opens the activation window
function Confirm-Activation
{
$WinVerAct = (cscript /Nologo "C:\Windows\System32\slmgr.vbs" /xpr) -join ''

if ($WinVerAct.Substring($WinVerAct.Length-31,31) -eq "Windows is in Notification mode")
{
Start-Process "ms-settings:activation"
}
}

#Set the timezone to CST and trigger a time sync with windows timeservers
function Set-Time
{
  Set-TimeZone -Id "Central America Standard Time"
  net start w32time
  W32tm /resync /force
}

#Check if the current proccess has admin priveleges
function Test-Admin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
    $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

#Finds recovery partitions and deletes them, then extends the previous partition
function fuckyou 
{
$Part = Get-Partition | Where-Object -FilterScript {$_.Type -Eq "Recovery" -or $_.Type -Eq "Unknown" }
if ($Part -ne $null)
{
    $PartNum = ($Part.PartitionNumber)
    $PartNum = $Partnum-1
    Remove-Partition -DiskNumber 0 -PartitionNumber $Part.PartitionNumber
    $sizeUp = (Get-PartitionSupportedSize -DiskNumber 0)
    $sizeUp = $sizeUp.SizeMax[1]
    Resize-Partition -DiskNumber 0 -PartitionNumber $PartNum -Size $sizeUp
    Write-Output "Resized Partition $PartNum!" 
}
}

if ((Test-Admin) -eq $false)  {
    if ($elevated) {
        # tried to elevate, did not work, aborting
    } else {
        Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -noexit -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition))
    }
    exit
}

Start-Transcript
Confirm-Activation
Set-Time
fuckyou
Stop-Transcript