param(
    [parameter(mandatory=$true)][string] $Name,
    [parameter(mandatory=$false)][int] $Instance = 0
)

$vdi_instance = '{0:d2}' -f [int]$(jq '.vagrant.instance' -r $PSScriptRoot\..\config.json)
$vdi_instance_fullname = "vdi-$vdi_instance"
$vdi_instance_machine_number = '{0:d2}' -f $Instance
$vdi_instance_machine_fullname = "${vdi_instance_fullname}-$Name-${vdi_instance_machine_number}"

import-module $PSScriptRoot/../provisioning/Windows/10/Ssh/Host/Remove-SshConfigHost -Force
import-module $PSScriptRoot/../provisioning/Windows/10/Ssh/Host/Clear-SshConfig -Force

Remove-SshConfigHost -Hostname $vdi_instance_machine_fullname
