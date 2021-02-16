
Kubernetes Development Environment
==================================

Help developers handle multiple Kubernetes clusters, with configurable number of masters (`dev-master`), workers  (`dev-worker`), side machines  (`dev`), which can sit and run on a PC portable.

Uses Packer to create Base box. You can create different base boxes.

Uses Vagrant to manage VirtualBox boxes.

Uses VirtualBox as VM runtime.

Works on Windows, MAC OSX, GNU/Linux.


# Cloning

```powershell
$instance=1
git clone git@github.com:French-Exception-2/vagranti-dev.php.git "vagranti-dev.php_i${instance}"
set-location "vagranti-dev.php_i${instance}"
```


# Configuring

```powershell
$instance=2
$group="Frenchex2 VagrantI I${instance}"
$keyboardLayout="us"
$env = "dev"

$masters = 1
$mastersRamMB = 2048
$mastersVcpus = 2
$mastersIpPattern = "10.100.2.#{NUMBER}"
$mastersIpStart = 2
$mastersBox = "docker-k8s"

$workers = 2
$workersRamMB = 3076
$workersVcpus = 2
$WorkersIPPattern = "10.100.2.#{NUMBER}"
$workersIpStart = 100
$workersBox = "docker-k8s"

$devs = 1
$devsRamMB = 1024
$devsVcpus = 4
$DevsIPPattern = "10.100.2.#{NUMBER}"
$DevsIpStart = 200
$devsBox = "debian/contrib-buster64"
$CodePath = "c:\\code\\"

# will produce ./config-$env.json
# will merge ./config.json & ./config-$env.json into ./instance/config.json
.\bin\Create-LocalConfig.ps1 -Group "$group" `
                             -Instance $instance `
                             -KeyboardLayout "$keyboardLayout" `
                             -Env "$env" `
                             -Masters $masters `
                             -MastersRam_MB $mastersRamMB `
                             -MastersVcpus $mastersVcpus `
                             -MastersIPPattern "$MastersIPPattern" `
                             -MastersIpStart $mastersIpStart `
                             -MastersBox "$mastersBox" `
                             -Workers $workers `
                             -WorkersRam_MB $workersRamMB `
                             -workersVcpus $workersVcpus `
                             -workersIpPattern "$workersIpPattern" `
                             -workersIpStart $workersIpStart `
                             -workersBox "$workersBox" `
                             -Devs $Devs `
                             -DevsRam_MB $devsRamMB `
                             -DevsVcpus $devsVcpus `
                             -DevsIPPattern "$DevsIPPattern" `
                             -DevsIpStart $DevsIpStart `
                             -devsBox "$DevsBox" `
                             -codepath "$codepath"

```

# Run Infrastructure Services

To help us save time and bandwidth usage, we will use an apt-cacher-ng instance.
It will be used by Packer boxes created and Vagrant machines when apt-get'ing.

```powershell
./bin/First-MachineBoot.ps1 -name "infra-dev"
```

# Packing Boxes

To avoid duplicate workloads, you can create boxes for Vagrant using Packer, before spawning your new Kubernetes cluster.

Creating a box let you install docker and kubernetes CLI tooling once and get it on all you Vagrant machines instances.

## Creating a new Box

First, we need to add a new Packer box definition, then build it.

```powershell
$boxName = "debian10"

# will create file box-debian10.json from template
./bin/Add-PackerBox.ps1 -name $boxName

# edit box-debian10.json file to fit your needs
# you may want to modify provisionings, disk sizing, etc.
code "./box-$boxName.json"

# then build box using packer
./bin/Build-PackerBox.ps1 -name debian10 `
                          -OS_Type Debian_64 `
                          -OS_Version 10.8.0 `
                          -Version 1.0.0 `
                          -BoxKind "docker-k8s" `
                          -VBoxGroup "Your Group"
```

# Running

```powershell
./bin/Bootstrap-Machines.ps1
```

# Scripts

## Host (PoSh)

| Name | Example call | Description |
| ---- | -------------| ------------|
| `./bin/Host/Windows/Install-Chocolatey.ps1`|  | |
| `./bin/Host/Windows/Install-Jq.ps1`|  | |
| `./bin/Host/Windows/Install-PoShModules.ps1`|  | |
| `./bin/Host/Windows/Install-PowerShellCore.ps1`|  | |
| `./bin/Host/Windows/Install-Vagrant.ps1`|  | |
| `./bin/Host/Windows/Install-VirtualBox.ps1`|  | |
| `./bin/Host/Windows/Install-Yq.ps1`|  | |
| `./bin/Add-PackerBox.ps1`|  | |
| `./bin/Bootstrap-Infrastructure.ps1`|  | |
| `./bin/Bootstrap-Machines.ps1`|  | |
| `./bin/Build-PackerBox.ps1`|  | |
| `./bin/Create-LocalConfig.ps1`|  | |
| `./bin/Create-MachineSnapshot.ps1`|  | |
| `./bin/Create-Directories.ps1`|  | |
| `./bin/Create-LocalConfig.ps1`|  | |
| `./bin/Create-MachineSnapshot.ps1`|  | |
| `./bin/First-MachineBoot.ps1`|  | |
| `./bin/Generate-InstanceConfig.ps1`|  | |
| `./bin/Halt-Machine.ps1`|  | |
| `./bin/Kill-Ruby.ps1`|  | |
| `./bin/Open-Code.ps1`|  | |
| `./bin/Provision-Machine.ps1`|  | |
| `./bin/Reload-Machine.ps1`|  | |
| `./bin/Remove-MachineSshHostConfig.ps1`|  | |
| `./bin/Restore-MachineSnapshot.ps1`|  | |
| `./bin/Ssh-Machine.ps1`|  | |
| `./bin/SshConfig-Machine.ps1`|  | |
| `./bin/Up-Machine.ps1`|  | |
| `./bin/Update-MachineSshHostConfig.ps1`|  | |


## Guest Provisioning

| OS Type | OS Version | Name | Example call | Description |
| ------- | ---------- | -----| -------------| ------------|
| Debian_64 | 10.8.0   | `apt-cacherng.install`|  | |
| Debian_64 | 10.8.0   | `apt.configure`|  | |
| Debian_64 | 10.8.0   | `apt.dist-upgrade`|  | |
| Debian_64 | 10.8.0   | `apt.dist-upgrade`|  | |
| Debian_64 | 10.8.0   | `apt.proxy.configure`|  | |
| Debian_64 | 10.8.0   | `apt.proxy.unconfigure`|  | |
| Debian_64 | 10.8.0   | `apt.update`|  | |
| Debian_64 | 10.8.0   | `apt.upgrade`|  | |
| Debian_64 | 10.8.0   | `cat-infos`|  | |
| Debian_64 | 10.8.0   | `clean.install`|  | |
| Debian_64 | 10.8.0   | `cleanup`|  | |
| Debian_64 | 10.8.0   | `dns.resolver.configure`|  | |
| Debian_64 | 10.8.0   | `docker-cli.configure`|  | |
| Debian_64 | 10.8.0   | `docker-cli.install`|  | |
| Debian_64 | 10.8.0   | `docker.compose.install`|  | |
| Debian_64 | 10.8.0   | `docker.configure`|  | |
| Debian_64 | 10.8.0   | `docker.context.remove.all`|  | |
| Debian_64 | 10.8.0   | `docker.install`|  | |
| Debian_64 | 10.8.0   | `gcloud.install`|  | |
| Debian_64 | 10.8.0   | `github.projects.clone`|  | |
| Debian_64 | 10.8.0   | `gitlab.cli.install`|  | |
| Debian_64 | 10.8.0   | `gitlab.cli.register-token`|  | |
| Debian_64 | 10.8.0   | `gitlab.projects.clone`|  | |
| Debian_64 | 10.8.0   | `gitlab.ssh-keyscan.sh`|  | |
| Debian_64 | 10.8.0   | `homebrew.install`|  | |
| Debian_64 | 10.8.0   | `ipv6.disable`|  | |
| Debian_64 | 10.8.0   | `jq.install`|  | |
| Debian_64 | 10.8.0   | `k8s-cli.configure`|  | |
| Debian_64 | 10.8.0   | `k8s.configure`|  | |
| Debian_64 | 10.8.0   | `k8s.install`|  | |
| Debian_64 | 10.8.0   | `keyboard.layout.configure`|  | |
| Debian_64 | 10.8.0   | `mysql.install`|  | |
| Debian_64 | 10.8.0   | `php.composer.install`|  | |
| Debian_64 | 10.8.0   | `php.xdebug.disable`|  | |
| Debian_64 | 10.8.0   | `php.xdebug.enable`|  | |
| Debian_64 | 10.8.0   | `phpbrew.install`|  | |
| Debian_64 | 10.8.0   | `powershell.install`|  | |
| Debian_64 | 10.8.0   | `python.pip.install`|  | |
| Debian_64 | 10.8.0   | `ssh.keys.configure`|  | |
| Debian_64 | 10.8.0   | `ssh.keys.copy`|  | |
| Debian_64 | 10.8.0   | `unzip`|  | |
| Debian_64 | 10.8.0   | `user.configure`|  | |
| Debian_64 | 10.8.0   | `yq.install`|  | |


