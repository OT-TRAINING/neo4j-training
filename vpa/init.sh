#!/bin/bash

VPA_GITHUB_LINK="https://github.com/kubernetes/autoscaler.git"
CA_LOCATION="/run/secrets/kubernetes.io/serviceaccount/ca.crt"
TOKEN=$(cat /run/secrets/kubernetes.io/serviceaccount/token)

if [[ "${VPA_GITHUB_LINK_BRANCH}" != "master" ]];
then
    if [[ "${VPA_GITHUB_LINK_BRANCH}" != "" ]];
    then
    rm -rf /opt/vpa/autoscaler
    git clone -b ${VPA_GITHUB_LINK_BRANCH} ${VPA_GITHUB_LINK}
    fi
fi

#KUBECTL_VERSION=$(curl -s --cacert $CA_LOCATION -X GET https://${API_SERVER}:8443/version --header "Authorization: Bearer ${TOKEN}"  | jq '.gitVersion' | awk -F\" '{print $2}')

wget "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

mv /opt/vpa/kubectl /bin
chmod +x /bin/kubectl
/bin/bash /opt/vpa/autoscaler/vertical-pod-autoscaler/hack/vpa-up.sh