## Kubernetes: VPA

Kubernetes provides multiple types of autoscaler capabilites through which we can scale up & down our pods or nodes on the basis of requirements. 

This guide will help you to setup Kubernetes VPA & to simulate the behaviour of VPA over pods.

## CONTEXT

- [VPA Setup]()
    - [prerequisite]()
    - [VPA Deployment]()
    - [Environment variables]()
- [Simulation]()

## VPA Setup

If you have already configured the VPA in your Kubernetes Cluster, skip the sub-step of VPA Setup and jump to [Simulation](). If not, please follow below each steps to configure VPA in Kubernetes cluster.

### prerequisite

This guide is only focusing on VPA part which means there is some prerequisite steps or deployments which user need to take care of.

prerequisite list: 

- [Kubernetes server]()
- [Metric server]()
- 

### VPA DEPLOYMENT

Jump to [CUSTOM STEP]() If there is requirement of different VPA Branch/Version, 

Use below command to setup Pod Job for kubernetes which will help user to deploy VPA in Kubernetes cluster.

```
kubectl apply -f vpa-setup.yaml
```

Resoruces list:

- Role
- RoleBinding
- ClusterRole
- ClusterROleBinding
- ServiceAccount
- Job

NOTE: The above manifest will configure a administrator access to cluster & kube-system namepsace for ServiceAccount and that service account will use by Job resources to configure and setup VPA.


### ENVIRONMENT VARIABLES


|name|default value|description|
|----|-----------|-------------|
|VPA_GITHUB_LINK_BRANCH|master|This signifies the branch/version of for kubernetes vertical pod autoscaler|

## CUSTOM SETUP

If there is requirement of different VPA version or branch, Add the `vpa-setup.yaml` manifest as below

```
env:
    - name: VPA_GITHUB_LINK_BRANCH
    value: "<BRANCHNAME>"
```

SAMPLE:

```
apiVersion: batch/v1
kind: Job
metadata:
  name: vpasetup
  namespace: kube-system
spec:
  template:
    spec:
      containers:
        - name: vpatest
          image: <IMAGE_REPONAME>:<TAG>   ## CHANGE THIS
          env:
            - name: VPA_GITHUB_LINK_BRANCH
                value: "<BRANCHNAME>"
            - name: API_SERVER
              valueFrom:
                fieldRef:
                  fieldPath: status.hostIP
      restartPolicy: Never
      serviceAccountName: vpasetup
```

## CHECK VPA SETUP

Check using below command to check if VPA setup or not.

```
kubectl get pods -n kube-system
```

OUTPUT:

```
vpa-updater-XXXXXXXXXX-XXXXX                1/1     Running             0               3s
vpa-recommender-XXXXXXXXXX-XXXXX            1/1     Running             0               4s
vpa-admission-controller-XXXXXXXXXX-XXXXX   1/1     Running             0               4s
```

## SIMULATION

If you didn't configure the VPA in Kubernetes cluster, please visit [VPA Setup]() section.