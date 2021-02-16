param(
)

# we first boot up infra services like apt cacher ng
. "$PSScriptRoot/First-MachineBoot.ps1" -name "infra-dev"

write-output ""
write-output "Now that Infrastructure services are up, "
write-output "You can create a Packer box,"
write-output "Or you can directly use Vagrant Cloud Boxes."
