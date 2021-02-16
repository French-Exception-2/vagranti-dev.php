param(
    [parameter(Mandatory=$true)][string]$Name,
    [parameter(Mandatory=$false)][int]$Instance = 0,
    [string] $Snapshot
)

$vdi_instance = '{0:d2}' -f [int]$(jq '.vagrant.instance' -r $PSScriptRoot\..\config.json)
$vdi_instance_fullname = "vdi-$vdi_instance"
$vdi_instance_machine_number = '{0:d2}' -f $Instance
$vdi_instance_machine_fullname = "${vdi_instance_fullname}-$Name-${vdi_instance_machine_number}"

vagrant snapshot save $vdi_instance_machine_fullname $Snapshot