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

function showCaseConfigMapEnvVariableMapping() {
    _runCommand "kubectl apply -f attendance-configmap.yaml"
    _runCommand "kubectl get configmap"
    _runCommand "kubectl describe configmap attendance-config"
    _clearScreen

    _runCommand "kubectl apply -f pod-env-indivdual.yaml"
    _runCommand "kubectl get pods"
    _runCommand "kubectl describe pod busybox"
    _runCommand "kubectl exec busybox -- sh -c 'echo \$USERNAME'"
    _runCommand "kubectl exec busybox -- sh -c 'echo \$PASSWORD'"
    _clearScreen

    _runCommand "kubectl delete -f pod-env-indivdual.yaml"
    _runCommand "kubectl delete -f attendance-configmap.yaml"
}

function showCaseConfigMapAllEnvVariableMapping() {
    _runCommand "kubectl apply -f attendance-configmap.yaml"
    _runCommand "kubectl get configmap"
    _runCommand "kubectl describe configmap attendance-config"
    _clearScreen

    _runCommand "kubectl apply -f pod-env-full.yaml"
    _runCommand "kubectl describe pod busybox"
    _runCommand "kubectl exec busybox -- sh -c 'echo \$mysql_username'"
    _runCommand "kubectl exec busybox -- sh -c 'echo \$mysql_password'"
    _clearScreen

    _runCommand "kubectl delete -f pod-env-full.yaml"
    _runCommand "kubectl delete -f attendance-configmap.yaml"
}