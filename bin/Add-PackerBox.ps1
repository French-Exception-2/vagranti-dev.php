param(
    [parameter(Mandatory=$true)][string] $Name
)

copy-item ./debian10.json.tpl "./box-$name.json"

write-output "You can now edit the file ./box-$name.json"
