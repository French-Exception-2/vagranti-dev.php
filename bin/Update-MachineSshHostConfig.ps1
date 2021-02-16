param(
    [parameter(mandatory = $false)][string] $Name,
    [parameter(Mandatory = $false)][string] $FullName,
    [parameter(mandatory = $false)][int] $Instance = 0
)

if ([string]::IsNullOrEmpty($Name) -and !([string]::IsNullOrEmpty($FullName))) {
    $vdi_instance_machine_fullname = $FullName
}
elseif(![string]::IsNullOrEmpty($Name)) {
    $vdi_instance = '{0:d2}' -f [int]$(jq '.vagrant.instance' -r $PSScriptRoot\..\instance\config.json)
    $vdi_instance_fullname = "vdi-$vdi_instance"
    $vdi_instance_machine_number = '{0:d2}' -f $Instance
    $vdi_instance_machine_fullname = "${vdi_instance_fullname}-$Name-${vdi_instance_machine_number}"
}

import-module $PSScriptRoot/../provisioning/Windows/10/Ssh/Host/Update-SshConfigHost -Force
import-module $PSScriptRoot/../provisioning/Windows/10/Ssh/Host/Add-SshConfigHost -Force
import-module $PSScriptRoot/../provisioning/Windows/10/Ssh/Host/Remove-SshConfigHost -Force
import-module $PSScriptRoot/../provisioning/Windows/10/Ssh/Host/Clear-SshConfig -Force

$script = { 
    $content = vagrant ssh-config $HostName # $HostName is scoped variable from Update-SshConfigHost callee
    $content
}

Update-SshConfigHost -Hostname $vdi_instance_machine_fullname -ConfigCommand $script
