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

function showCaseSecretCreationFromManifestWithEncodedString() {
    _runCommand "cat db-creds-encoded.yaml"
    _runCommand "kubectl apply -f db-creds-encoded.yaml"
    _runCommand "kubectl get secrets"
    _runCommand "kubectl describe secret db-creds-encoded"
    _runCommand "kubectl get secret db-creds-encoded -o jsonpath='{.data}'"
    _runCommand "kubectl get secret db-creds-encoded -o jsonpath='{.data.username}' | base64 --decode"
    _runCommand "kubectl get secret db-creds-encoded -o jsonpath='{.data.password}' | base64 --decode"
    _clearScreen

    _runCommand "kubectl delete -f db-creds-encoded.yaml"
}

function showCaseSecretCreationFromManifestWithSimpleString() {
    _runCommand "cat db-creds-simple.yaml"
    _runCommand "kubectl apply -f db-creds-simple.yaml"
    _runCommand "kubectl get secrets"
    _runCommand "kubectl describe secret db-creds-simple"
    _runCommand "kubectl get secret db-creds-simple -o jsonpath='{.data}'"
    _runCommand "kubectl get secret db-creds-simple -o jsonpath='{.data.username}' | base64 --decode"
    _runCommand "kubectl get secret db-creds-simple -o jsonpath='{.data.password}' | base64 --decode"
    _clearScreen

    _runCommand "kubectl delete -f db-creds-simple.yaml"
}
