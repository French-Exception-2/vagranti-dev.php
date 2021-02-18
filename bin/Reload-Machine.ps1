param(
    [parameter(mandatory=$true)][string] $Name,
    [parameter(mandatory=$false)][int] $Instance = 0,
    [switch] $Force
)

$vdi_instance = '{0:d2}' -f [int]$(jq '.vagrant.instance' -r $PSScriptRoot\..\instance\config.json)
$vdi_instance_fullname = "vdi-$vdi_instance"
$vdi_instance_machine_number = '{0:d2}' -f $Instance
$vdi_instance_machine_fullname = "${vdi_instance_fullname}-$Name-${vdi_instance_machine_number}"

$force_cmd_arg = $Force.IsPresent ? "--force" : ""

vagrant reload $force_cmd_arg $vdi_instance_machine_fullname
vagrant hostmanager $vdi_instance_machine_fullname

. "$PSScriptRoot\\Update-MachineSshHostConfig.ps1" -fullname $vdi_instance_machine_fullname