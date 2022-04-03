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

function showCaseSecretCreationFromFile() {
    _runCommand "kubectl create secret generic db-creds --from-file=./USERNAME --from-file=./PASSWORD"
    _runCommand "kubectl get secrets"
    _runCommand "kubectl describe secret db-creds"
    _runCommand "kubectl get secret db-creds -o jsonpath='{.data.USERNAME}' | base64 --decode"
    _runCommand "kubectl get secret db-creds -o jsonpath='{.data.PASSWORD}' | base64 --decode"
    _clearScreen

    _runCommand "kubectl delete secret db-creds"
}

function showCaseSecretCreationFromLiteral() {
    _runCommand "kubectl create secret generic db-creds --from-literal=USERNAME=opstree --from-literal=PASSWORD=password"
    _runCommand "kubectl get secrets"
    _runCommand "kubectl describe secret db-creds"
    _runCommand "kubectl get secret db-creds -o jsonpath='{.data.USERNAME}' | base64 --decode"
    _runCommand "kubectl get secret db-creds -o jsonpath='{.data.PASSWORD}' | base64 --decode"
    _clearScreen

    _runCommand "kubectl delete secret db-creds"
}
