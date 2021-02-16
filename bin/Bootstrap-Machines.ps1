
$mastersInstances = $(jq -r '.nodes."dev-master".instances' /vagrant/instance/config.json)

for($i=0;$i -lt $mastersInstances; $i++){
    ./$PSScriptRoot/First-MachineBoot.ps1 -name dev-master -instance $i
}

$workersInstances = $(jq -r '.nodes["dev-worker"].instances' /vagrant/instance/config.json)

for($i=0;$i -lt $workersInstances; $i++){
    ./$PSScriptRoot/First-MachineBoot.ps1 -name dev-worker -instance $i
}

$devsInstances = $(jq -r '.nodes.dev.instances' /vagrant/instance/config.json)

for($i=0;$i -lt $devsInstances; $i++){
    ./$PSScriptRoot/First-MachineBoot.ps1 -name dev -instance $i
}
