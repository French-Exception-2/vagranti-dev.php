param(
    [parameter(Mandatory=$false)][string] $Name = "debian10",
    [parameter(Mandatory=$false)][string] $OS_Type = "Debian_64",
    [parameter(Mandatory=$false)][string] $OS_Version = "10.8.0",
    [parameter(Mandatory=$false)][string] $Version = "0.0.1",
    [parameter(Mandatory=$false)][string] $BoxKind= "docker-k8s",
    [parameter(Mandatory=$false)][string] $VBoxGroup = "Frenchex VagrantI"
)

$boxjson = "box-${Name}.json"

$version_str = $Version.Replace('.','-').Replace('_', '-')
$out = "virtualbox-${OS_Type}-${OS_Version}-${boxkind}-amd64".Replace('_', '-')

packer build `
    -var "version=${Version}" `
    -var "version_str=$version_str" `
    -var "name=$Name" `
    -var "os_version=$OS_Version" `
    -var "os_type=$OS_Type" `
    -var "box_kind=$boxkind" `
    -var "vbox_group=$VBoxGroup" `
    -var "out=$out" `
    $boxjson 

vagrant box add builds/${out}.box --name $BoxKind -f
