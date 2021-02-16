param(
    [parameter(Mandatory=$false)][string] $Env = "dev"
)

jq -s '.[0] * .[1]' config.json "config-${env}.json"  | out-file instance/config.json -Encoding ASCII
