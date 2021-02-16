param(
    [parameter(Mandatory=$true)][int] $Instance,
    [parameter(Mandatory=$true)][string] $Group,
    
    [parameter(Mandatory=$false)][string] $KeyboardLayout = "us",

    [parameter(Mandatory=$false)][string] $CodePath = "c:\\code",

    [parameter(Mandatory=$false)][string] $Env = "dev",

    [parameter(Mandatory=$false)][int] $Masters = 1,
    [parameter(Mandatory=$false)][int] $MastersRam_MB = 2048,
    [parameter(Mandatory=$false)][int] $MastersVCPUs = 2,
    [parameter(Mandatory=$false)][string] $MastersIPPattern = "10.100.2.#{NUMBER}",
    [parameter(Mandatory=$false)][string] $MastersIPStart = 2,
    [parameter(Mandatory=$false)][string] $MastersBox = "debian/contrib-buster64",
    
    
    [parameter(Mandatory=$false)][int] $Workers = 1,
    [parameter(Mandatory=$false)][int] $WorkersVCPUs = 2,
    [parameter(Mandatory=$false)][int] $WorkersRam_MB = 3072,
    [parameter(Mandatory=$false)][string] $WorkersIPPattern = "10.100.2.#{NUMBER}",
    [parameter(Mandatory=$false)][string] $WorkersIPStart = 5,
    [parameter(Mandatory=$false)][string] $WorkersBox = "debian/contrib-buster64",
    

    [parameter(Mandatory=$false)][int] $Devs = 1,
    [parameter(Mandatory=$false)][int] $DevsVCPUS = 4,
    [parameter(Mandatory=$false)][int] $DevsRam_MB = 1024,
    [parameter(Mandatory=$false)][string] $DevsIPPattern = "10.100.3.#{NUMBER}",
    [parameter(Mandatory=$false)][string] $DevsIPStart = 2,
    [parameter(Mandatory=$false)][string] $DevsBox = "debian/contrib-buster64"

)

$content= @"
{
    "vagrant": {
        "instance": $Instance,
        "group": "$Group",
        "keyboard-layout": "$KeyboardLayout"
    },
    "nodes": {
        "dev-master": {
            "instances": $Masters,
            "ram_mb": $MastersRam_MB,
            "vcpus": $MastersVCPUs,
            "ip": "$MastersIPPattern",
            "ip.start": $MastersIPStart,
            "box": "$MastersBox"
        },
        "dev-worker": {
            "instances": $Workers,
            "ram_mb": $WorkersRam_MB,
            "vcpus": $WorkersVCPUs,
            "ip": "$WorkersIPPattern",
            "ip.start": $WorkersIPStart,
            "box": "$WorkersBox"
        },
        "dev": {
            "instances": $Devs,
            "ram_mb": $DevsRam_MB,
            "vcpus": $DevsVCPUS,
            "ip": "$DevsIPPattern",
            "ip.start": $DevsIPStart,
            "box": "$DevsBox",
            "shared_folders": {
                "code": {
                    "host_path": "$CodePath"
                }
            }
        }
    }
}
"@

$content | out-file config-$env.json -force

./bin/Generate-InstanceConfig.ps1 -Env $env