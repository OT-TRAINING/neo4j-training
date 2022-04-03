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

function showCaseSecretMount() {
    _runCommand "kubectl apply -f db-creds.yaml"
    _runCommand "kubectl get secrets"
    _runCommand "kubectl describe secret db-creds"
    _runCommand "kubectl get secret db-creds -o jsonpath='{.data.credential}' | base64 --decode"
    _clearScreen

    _runCommand "kubectl apply -f pod-volume.yaml"
    _runCommand "kubectl describe pod busybox"
    _runCommand "kubectl exec busybox -- sh -c 'ls /etc/db'"
    _runCommand "kubectl exec busybox -- sh -c 'cat /etc/db/credential'"
    _clearScreen

    _runCommand "echo 'Update the secret'"
    _runCommand "kubectl apply -f db-creds.yaml"
    _runCommand "kubectl get secret db-creds -o jsonpath='{.data.credential}' | base64 --decode"
    _runCommand "kubectl exec busybox -- sh -c 'cat /etc/db/credential'"
    _clearScreen

    _runCommand "kubectl delete -f pod-volume.yaml"
    _runCommand "kubectl delete -f db-creds.yaml"
}


function showCaseSecretEnvVariableMapping() {
    _runCommand "kubectl apply -f db-creds.yaml"
    _runCommand "kubectl get secrets"
    _runCommand "kubectl describe secret db-creds"
    _runCommand "kubectl get secret db-creds -o jsonpath='{.data.username}' | base64 --decode"
    _runCommand "kubectl get secret db-creds -o jsonpath='{.data.password}' | base64 --decode"
    _clearScreen

    _runCommand "kubectl apply -f pod-env-indivdual.yaml"
    _runCommand "kubectl describe pod busybox"
    _runCommand "kubectl exec busybox -- sh -c 'echo \$USERNAME'"
    _runCommand "kubectl exec busybox -- sh -c 'echo \$PASSWORD'"
    _clearScreen

    _runCommand "kubectl delete -f pod-env-indivdual.yaml"
    _runCommand "kubectl delete -f db-creds.yaml"
}

function showCaseSecretAllEnvVariableMapping() {
    _runCommand "kubectl apply -f db-creds.yaml"
    _runCommand "kubectl get secrets"
    _runCommand "kubectl describe secret db-creds"
    _runCommand "kubectl get secret db-creds -o jsonpath='{.data.credential}' | base64 --decode"
    _runCommand "kubectl get secret db-creds -o jsonpath='{.data.username}' | base64 --decode"
    _runCommand "kubectl get secret db-creds -o jsonpath='{.data.password}' | base64 --decode"
    _clearScreen

    _runCommand "kubectl apply -f pod-env-full.yaml"
    _runCommand "kubectl describe pod busybox"
    _runCommand "kubectl exec busybox -- sh -c 'echo \$username'"
    _runCommand "kubectl exec busybox -- sh -c 'echo \$password'"
    _clearScreen

    _runCommand "kubectl delete -f pod-env-full.yaml"
    _runCommand "kubectl delete -f db-creds.yaml"
}