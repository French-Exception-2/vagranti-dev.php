param(
    [parameter(mandatory=$true)][string] $Name,
    [parameter(mandatory=$false)][int] $Instance = 0,
    [switch] $Force
    
)

$vdi_instance = '{0:d2}' -f [int]$(jq '.vagrant.instance' -r $PSScriptRoot\..\config.json)
$vdi_instance_fullname = "vdi-$vdi_instance"
$vdi_instance_machine_number = '{0:d2}' -f $Instance

if ($force.IsPresent){
    vagrant halt -f "${vdi_instance_fullname}-$Name-${vdi_instance_machine_number}"

} else {
    vagrant halt "${vdi_instance_fullname}-$Name-${vdi_instance_machine_number}"
}
