
$mastersInstances = $(jq -r '.nodes.\"dev-master\".instances' ./instance/config.json)

for ($i = 0; $i -lt $mastersInstances; $i++) {
    Write-Output "dev-master $i"
    . "$PSScriptRoot/Destroy-Machine.ps1" -name dev-master -instance $i
}

$workersInstances = $(jq -r '.nodes.\"dev-worker\".instances' ./instance/config.json)

for ($i = 0; $i -lt $workersInstances; $i++) {
    Write-Output "dev-worker $i"
    . "$PSScriptRoot/Destroy-Machine.ps1" -name dev-worker -instance $i
}

$devsInstances = $(jq -r '.nodes.dev.instances' ./instance/config.json)

for ($i = 0; $i -lt $devsInstances; $i++) {
    Write-Output "dev $i"
    . "$PSScriptRoot/Destroy-Machine.ps1" -name dev -instance $i
}
