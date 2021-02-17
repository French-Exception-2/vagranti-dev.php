param(
    [switch] $Formatted,
    [string] $Format = '{0:d2}'
)

$vagrant_instance = $(jq -r '.vagrant.instance' ./instance/config.json)

if ($Formatted.ispresent && ![string]::isnullorempty($format)) {
    $format -f $vagrant_instance
} else {
    $vagrant_instance
}