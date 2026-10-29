#!/bin/bash
set -e

INFRA_DIR="$(dirname "$0")/.infrastructure"

# namespace first: everything else lives in it
kubectl apply -f "$INFRA_DIR/namespace.yml"

# configuration the deployment mounts
kubectl apply -f "$INFRA_DIR/confgiMap.yml"
kubectl apply -f "$INFRA_DIR/secret.yml"

# storage: PV (cluster-wide) and then the PVC that claims it
kubectl apply -f "$INFRA_DIR/pv.yml"
kubectl apply -f "$INFRA_DIR/pvc.yml"

# application, services and autoscaler
kubectl apply -f "$INFRA_DIR/deployment.yml"
kubectl apply -f "$INFRA_DIR/clusterIp.yml"
kubectl apply -f "$INFRA_DIR/nodeport.yml"
kubectl apply -f "$INFRA_DIR/hpa.yml"

kubectl rollout status deployment/todoapp -n todoapp --timeout=180s
kubectl get pv,pvc,pods -n todoapp
