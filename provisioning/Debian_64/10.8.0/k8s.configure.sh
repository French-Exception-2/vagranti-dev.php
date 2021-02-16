#!/usr/bin/env bash

sudo swapoff -a

if [[ $MASTER == $(hostname) ]]; then
    k_iface=${k_iface:=enp0s8}
    k_apiserver_advertise_address=${k_apiserver_advertise_address:=$(ip addr show $k_iface | grep -Po 'inet \K[\d.]+')}
    k_pod_network_cidr=${k_pod_network_cidr:="172.18.0.0/16"}

    sudo kubeadm init --apiserver-advertise-address=${k_apiserver_advertise_address} --pod-network-cidr=${k_pod_network_cidr} 
    mkdir -p $HOME/.kube
    (rm /vagrant/instance/k8s.conf) || true
    sudo cp -i /etc/kubernetes/admin.conf /vagrant/instance/k8s.conf
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config
    kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
    kubeadm token create --print-join-command > /vagrant/instance/k8s.join.command.create.sh
    cat /vagrant/instance/k8s.join.command.create.sh
    chmod +x /vagrant/instance/k8s.join.command.create.sh
    sudo cp -f /var/lib/kubelet/pki/kubelet-client-current.pem /vagrant/instance/kubelet-client-current.pem

    config=$(cat <<EOF
{
    "config": "/vagrant/instance/k8s.conf"
}    
EOF
)
    echo "$config" | tee /vagrant/instance/kubernetes-hosts/$(hostname).json
else
    ROLE=${ROLE:="master"}
    mkdir -p $HOME/.kube
    sudo cp -fi /vagrant/instance/k8s.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config
    sudo mkdir -p /var/lib/kubelet/pki/
    sudo cp -fi /vagrant/instance/kubelet-client-current.pem /var/lib/kubelet/pki/kubelet-client-current.pem
    (sudo bash /vagrant/instance/k8s.join.command.create.sh) || true # will fail after timeout 40s
    sudo kubeadm reset -f
    sudo bash /vagrant/instance/k8s.join.command.create.sh
    kubectl label nodes $(hostname) kubernetes.io/role=${ROLE}
fi

kubectl cluster-info
