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

#Creation & deletion sequence is wrong, it's just to showcase the behaviour
function showCaseStaticPV() {
    _runCommand "kubectl apply -f pod.yaml"
    _runCommand "cat pod.yaml"
    _runCommand "kubectl get pods"
    _runCommand "kubectl describe pod pv-reader"
    _runCommand "kubectl get pvc"
    _clearScreen
    
    _runCommand "kubectl apply -f pvc.yaml"
    _runCommand "cat pvc.yaml"
    _runCommand "kubectl get pvc"
    _runCommand "kubectl get pv"
    _runCommand "kubectl describe pvc aws-pvc-hunt"
    _runCommand "kubectl get pods"
    _clearScreen

    _runCommand "kubectl apply -f pv.yaml"
    _runCommand "cat pv.yaml"
    _runCommand "kubectl get pv"
    _runCommand "kubectl describe pv aws-pv-hunt"
    _clearScreen

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

    _runCommand "kubectl delete -f pv.yaml"
}
