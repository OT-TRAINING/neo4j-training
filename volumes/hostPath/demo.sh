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

function showCaseHostPathDir() {
    _runCommand "kubectl apply -f pod-writer.yaml"
    _runCommand "kubectl describe pod busybox-writer"
    _runCommand "kubectl apply -f pod-reader.yaml"
    _runCommand "kubectl describe pod busybox-reader"
    _runCommand "kubectl exec busybox-reader -c reader -- sh -c 'ls /data'"
    _runCommand "kubectl exec busybox-writer -c writer -- sh -c 'ls /data'"
    _runCommand "kubectl exec busybox-writer -c writer -- sh -c 'echo \"writing from writer\" > /data/writer/writer.txt'"
    _runCommand "kubectl exec busybox-reader -c reader -- sh -c 'cat  /data/reader/writer.txt'"
    _clearScreen

    _runCommand "kubectl delete -f pod-reader.yaml"
    _runCommand "kubectl delete -f pod-writer.yaml"
}

