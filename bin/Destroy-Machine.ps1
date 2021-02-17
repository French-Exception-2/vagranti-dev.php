param(
    [parameter(mandatory=$true)][string] $Name,
    [parameter(mandatory=$false)][int] $Instance = 0
    
)

$vdi_instance = '{0:d2}' -f [int]$(jq '.vagrant.instance' -r $PSScriptRoot\..\instance\config.json)
$vdi_instance_fullname = "vdi-$vdi_instance"
$vdi_instance_machine_number = '{0:d2}' -f $Instance
$vdi_instance_machine_fullname = "${vdi_instance_fullname}-$Name-${vdi_instance_machine_number}"

vagrant destroy -f $vdi_instance_machine_fullname
