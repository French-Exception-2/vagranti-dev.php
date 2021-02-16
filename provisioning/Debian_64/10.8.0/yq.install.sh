#!/usr/bin/env bash

sudo apt-get install -y python3-pip
echo "export PATH=/home/vagrant/.local/bin:\$PATH" | tee -a $HOME/.bashrc
pip3 install yq
