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

function showCaseCreateFromDir() {
    _runCommand "ls configs"
    _runCommand "cat configs/attendance.yaml"
    _runCommand "cat configs/employee.yaml"
    _runCommand "kubectl create configmap otms-config --from-file=configs"
    _runCommand "kubectl get configmap"
    _runCommand "kubectl describe configmap otms-config" 
    _runCommand "kubectl delete configmap otms-config"
}

function showCaseCreateFromFile() {
    _runCommand "ls configs"
    _runCommand "cat configs/attendance.yaml"
    _runCommand "cat configs/employee.yaml"
    _runCommand "kubectl create configmap otms-config --from-file=configs/attendance.yaml --from-file=configs/employee.yaml"
    _runCommand "kubectl get configmap"
    _runCommand "kubectl describe configmap otms-config" 
    _runCommand "kubectl delete configmap otms-config"
}

function showCaseCreateFromEnvFile() {
    _runCommand "ls configs"
    _runCommand "cat configs/employee.properties"
    _runCommand "kubectl create configmap otms-config --from-env-file=configs/employee.properties"
    _runCommand "kubectl get configmap"
    _runCommand "kubectl describe configmap otms-config" 
    _runCommand "kubectl delete configmap otms-config"

}

function showCaseCreateFromLiteral() {
    _runCommand "kubectl create configmap otms-config --from-file=configs/attendance.yaml --from-file=configs/employee.yaml"

}