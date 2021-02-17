param(
    [parameter(Mandatory=$false)][string] $Name = "debian10",
    [parameter(Mandatory=$false)][string] $KernelVersion = "5.9.0-0.bpo.5",
    [parameter(Mandatory=$false)][string] $OS_Type = "debian_64",
    [parameter(Mandatory=$false)][string] $OS_Version = "10.8.0",
    [parameter(Mandatory=$false)][string] $Version = "0.0.1",
    [parameter(Mandatory=$false)][string] $BoxKind= "docker-kubernetes",
    [parameter(Mandatory=$false)][string] $BoxSizeMB= "81920",
    [parameter(Mandatory=$false)][string] $VBoxGroup = "Frenchex VagrantI"
)

$boxjson = "box-${Name}.json"

$version_str = $Version.Replace('.','-').Replace('_', '-')

. "$PSSCriptRoot/../provisioning/Windows/10/Util.ps1"
$humanSizeGb = Convert-Size -from "MB" -to "GB" -value "81920"

$out = "virtualbox-${OS_Type}-${OS_Version}-${kernelVersion}-${boxkind}-amd64-${humanSizeGb}GB".Replace('_', '-')

packer build `
    -var "version=${Version}" `
    -var "version_str=$version_str" `
    -var "name=$Name" `
    -var "os_version=$OS_Version" `
    -var "os_type=$OS_Type" `
    -var "box_kind=$boxkind" `
    -var "vbox_group=$VBoxGroup" `
    -var "out=$out" `
    -var "size_mb=$BoxSizeMB" `
    -var "kernel_version=$KernelVersion" `
    $boxjson 

vagrant box add builds/${out}.box --name $BoxKind -f
