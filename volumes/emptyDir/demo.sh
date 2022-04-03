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

function showCaseEmptyDir() {
    _runCommand "kubectl apply -f pod.yaml"
    _runCommand "kubectl describe pod busybox"
    _runCommand "kubectl exec busybox -c reader -- sh -c 'ls /data'"
    _runCommand "kubectl exec busybox -c writer -- sh -c 'ls /data'"
    _runCommand "kubectl exec busybox -c reader -- sh -c 'echo \"writing from reader\" > /data/reader/reader.txt'"
    _runCommand "kubectl exec busybox -c writer -- sh -c 'echo \"writing from writer\" > /data/writer/writer.txt'"
    _runCommand "kubectl exec busybox -c reader -- sh -c 'cat  /data/reader/writer.txt'"
    _clearScreen

    _runCommand "kubectl delete -f pod.yaml"
}

