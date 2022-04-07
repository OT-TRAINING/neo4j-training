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
    local namespace=$2
    CA_LOCATION=~/.minikube
    _runCommand "openssl genrsa -out ${user}.key 2048"
    _runCommand "openssl req -new -key ${user}.key -out ${user}.csr -subj '/CN=${user}/O=bitnami'"
    _runCommand "openssl x509 -req -in ${user}.csr -CA ${CA_LOCATION}/ca.crt -CAkey ${CA_LOCATION}/ca.key -CAcreateserial -out ${user}.crt -days 500"
    _runCommand "kubectl config set-credentials ${user} --client-certificate=${user}.crt  --client-key=${user}.key"
    _runCommand "kubectl config set-context ${user}-context --cluster=minikube --namespace=${namespace} --user=${user}"
}

function _cleanupUserCreds() {
    local user=$1
    _runCommand "rm ${user}.key"
    _runCommand "rm ${user}.csr"
    _runCommand "rm ${user}.crt"
    _runCommand "kubectl config delete-context ${user}-context"
    _runCommand "kubectl config unset users.${user}"
}

function _setup() {
    _runCommand "kubectl create namespace demo"
    _generateUserCreds sandy demo
    _generateUserCreds abhi demo
}

function showCaseNoAccess() {
    _runCommand "kubectl --context=sandy-context get pods"
    _runCommand "kubectl --context=abhi-context get pods"
}

function _tearDown() {
    _runCommand "kubectl delete namespace demo"
    _cleanupUserCreds sandy
    _cleanupUserCreds abhi
}
