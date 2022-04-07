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

function showCaseDynamicPV() {
    _runCommand "kubectl apply -f storage-class.yaml"
    _runCommand "cat storage-class.yaml"
    _runCommand "kubectl get sc"
    _runCommand "kubectl describe sc standard-hunt"
    _clearScreen
    
    _runCommand "cat pvc.yaml"
    _runCommand "kubectl apply -f pvc.yaml"
    _runCommand "kubectl get pvc"
    _runCommand "kubectl describe pvc dynamic-pvc"
    _runCommand "kubectl get pv"
    _clearScreen

   
   _runCommand "cat pod.yaml"
    _runCommand "kubectl apply -f pod.yaml"
    _runCommand "kubectl get pods"
    _runCommand "kubectl describe pod pv-reader"
    _clearScreen

    _runCommand "kubectl delete -f pod.yaml"
    _runCommand "kubectl get pvc"
    _runCommand "kubectl get pv"
    _clearScreen

    _runCommand "kubectl delete -f pvc.yaml"
    _runCommand "kubectl get pvc"
    _runCommand "kubectl get pv"
    _clearScreen

    PV_NAME=`kubectl get pv | grep standard-hunt  | awk '{print $1}'`
    _runCommand "kubectl delete pv $PV_NAME"
}
