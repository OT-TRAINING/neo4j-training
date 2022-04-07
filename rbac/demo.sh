#!/bin/bash

function _logMessage() {
    local message=$1
    echo ""
    echo "${message}"
}

function _pauseScreen() {
    read -p "Press any key to continue......" ignore
}

function _runCommand() {
    local command=$1
    _logMessage "Running [$command]"
    _pauseScreen
    bash -c "${command}"
}

function _clearScreen() {
    echo ""
    read -p "Press a key to clear screen......" ignore
    clear
}

function _generateUserCreds() {
    local user=$1
    local group=$2
    local namespace=$3
    CA_LOCATION=~/.minikube
    _runCommand "openssl genrsa -out ${user}.key 2048"
    _runCommand "openssl req -new -key ${user}.key -out ${user}.csr -subj '/CN=${user}/O=${group}'"
    _runCommand "openssl x509 -req -in ${user}.csr -CA ${CA_LOCATION}/ca.crt -CAkey ${CA_LOCATION}/ca.key -CAcreateserial -out ${user}.crt -days 500"
    _runCommand "kubectl config set-credentials ${user} --client-certificate=${user}.crt  --client-key=${user}.key"
    _runCommand "kubectl config set-context ${user}-context --cluster=minikube --namespace=${namespace} --user=${user}"
}



function _setup() {
    _runCommand "kubectl create namespace demo"
    _generateUserCreds sandy devops demo
    _generateUserCreds abhi dev demo
}

function showCaseReadOnlyForUser() {
    _runCommand "kubectl --context=sandy-context get pods"
    _runCommand "kubectl --context=abhi-context get pods"
    _clearScreen

    _runCommand "kubectl apply -f roles/readOnlySandy.yaml"
    _runCommand "cat roles/readOnlySandy.yaml"
    _runCommand "kubectl --context=sandy-context get pods"
    _runCommand "kubectl --context=abhi-context get pods"
    _runCommand "kubectl delete -f roles/readOnlySandy.yaml"
    _clearScreen

    _runCommand "kubectl apply -f roles/readOnlyAbhi.yaml"
    _runCommand "cat roles/readOnlyAbhi.yaml"
    _runCommand "kubectl --context=sandy-context get pods"
    _runCommand "kubectl --context=abhi-context get pods"
    _runCommand "kubectl delete -f roles/readOnlyAbhi.yaml"
}

function showCaseReadWriteForUser() {
    _runCommand "kubectl apply -f roles/readAbhiWriteSandy.yaml"
    _runCommand "cat roles/readAbhiWriteSandy.yaml"
    _clearScreen

    _runCommand "kubectl --context=abhi-context apply -f pods/pod.yaml"
    _runCommand "kubectl --context=sandy-context apply -f pods/pod.yaml"
    _clearScreen

    _runCommand "kubectl --context=sandy-context get pods"
    _runCommand "kubectl --context=abhi-context get pods"
    _clearScreen
    
    _runCommand "kubectl --context=abhi-context delete -f pods/pod.yaml"
    _runCommand "kubectl --context=sandy-context delete -f pods/pod.yaml"
    _clearScreen

    _runCommand "kubectl delete -f roles/readAbhiWriteSandy.yaml"
}

function showCaseReadOnlyForGroup() {
    _runCommand "kubectl --context=sandy-context get pods"
    _runCommand "kubectl --context=abhi-context get pods"
    _clearScreen

    _runCommand "kubectl apply -f roles/readOnlyDevOpsGroup.yaml"
    _runCommand "cat roles/readOnlyDevOpsGroup.yaml"
    _runCommand "kubectl --context=sandy-context get pods"
    _runCommand "kubectl --context=abhi-context get pods"
    _runCommand "kubectl delete -f roles/readOnlyDevOpsGroup.yaml"
    _clearScreen
}

function showCaseReadWriteForGroup() {
    _runCommand "kubectl apply -f roles/readWriteGroup.yaml"
    _runCommand "cat roles/readWriteGroup.yaml"
    _clearScreen

    _runCommand "kubectl --context=abhi-context apply -f pods/pod.yaml"
    _runCommand "kubectl --context=sandy-context apply -f pods/pod.yaml"
    _clearScreen

    _runCommand "kubectl --context=sandy-context get pods"
    _runCommand "kubectl --context=abhi-context get pods"
    _clearScreen
    
    _runCommand "kubectl --context=abhi-context delete -f pods/pod.yaml"
    _runCommand "kubectl --context=sandy-context delete -f pods/pod.yaml"
    _clearScreen

    _runCommand "kubectl delete -f roles/readWriteGroup.yaml"
}
function _generateTokenCreds() {
    NAMESPACE=$1
    POD_NAME=$2
    SA_USER=$3

    TOKEN=`kubectl exec ${POD_NAME} -n ${NAMESPACE} -- sh -c "cat /var/run/secrets/kubernetes.io/serviceaccount/token"`

    kubectl config set-credentials ${SA_USER} --token=$TOKEN
    kubectl config set-context ${SA_USER}-context --cluster=minikube --namespace=${NAMESPACE} --user=${SA_USER}
}

function showCaseServiceAccount() {
    _runCommand "kubectl apply -f sa/roles.yaml"
    _runCommand "cat sa/roles.yaml"
    _clearScreen

    _runCommand "kubectl apply -f sa/sa.yaml"
    _runCommand "cat sa/sa.yaml"
    _clearScreen

    _runCommand "kubectl apply -f sa/sa-role-binding.yaml"
    _runCommand "cat sa/sa-role-binding.yaml"
    _clearScreen

    _runCommand "kubectl apply -f sa/pod.yaml -n demo"
    _runCommand "sleep 30s"
    
    _generateTokenCreds demo jenkins-busybox jenkins-sa
    _generateTokenCreds demo debug-busybox debug-sa
    _runCommand "kubectl delete -f sa/pod.yaml -n demo"
    _clearScreen

    _runCommand "kubectl --context=debug-sa-context apply -f sa/pod.yaml"
    _runCommand "kubectl --context=jenkins-sa-context apply -f sa/pod.yaml"
    _clearScreen

    _runCommand "kubectl --context=jenkins-sa-context get pods"
    _runCommand "kubectl --context=debug-sa-context get pods"
    _clearScreen
    
    _runCommand "kubectl --context=debug-sa-context delete -f sa/pod.yaml"
    _runCommand "kubectl --context=jenkins-sa-context delete -f sa/pod.yaml"
    _clearScreen
    
    _cleanupTokenCreds jenkins-sa
    _cleanupTokenCreds debug-sa
    _runCommand "kubectl delete -f sa/sa-role-binding.yaml"
    _runCommand "kubectl delete -f sa/sa.yaml"
    _runCommand "kubectl delete -f sa/roles.yaml"
}

function _cleanupTokenCreds() {
    local user=$1
    _runCommand "kubectl config delete-context ${user}-context"
    _runCommand "kubectl config unset users.${user}"
}

function _cleanupUserCreds() {
    local user=$1
    _runCommand "rm ${user}.key"
    _runCommand "rm ${user}.csr"
    _runCommand "rm ${user}.crt"
    _runCommand "kubectl config delete-context ${user}-context"
    _runCommand "kubectl config unset users.${user}"
}

function _tearDown() {
    _runCommand "kubectl delete namespace demo"
    _cleanupUserCreds sandy
    _cleanupUserCreds abhi
}
