
if (!(test-path instance)) {
    new-item -ItemType directory -path instance
}

if (!(test-path instance/ssh)) {
    new-item -ItemType Directory -path instance/ssh
    copy-item -Path $HOME/.ssh/id_* -Destination instance/ssh/
}