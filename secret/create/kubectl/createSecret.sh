#!/bin/bash

function _logMessage() {
    local message=$1

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
    read -p "Press a key to clear screen......" ignore
    clear
}

function showCaseSecretCreationFromFile() {
    _runCommand "kubectl create secret generic db-creds --from-file=./DB_CREDS.properties"
    _runCommand "kubectl get secrets"
    _runCommand "kubectl describe secret db-creds"
    _clearScreen

    _runCommand "kubectl delete secret db-creds"
}