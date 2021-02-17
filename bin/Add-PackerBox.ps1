param(
    [parameter(Mandatory=$true)][string] $Name,
    [parameter(Mandatory=$false)][string] $Template = "debian10"
)

copy-item "./$Template.json.tpl" "./box-$name.json"

write-output "You can now edit the file ./box-$name.json"
