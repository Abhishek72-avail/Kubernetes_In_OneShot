#!/bin/bash
# File: cleanup.sh

NAMESPACE="web-app"

echo "Cleaning up Kubernetes resources..."

# Delete resources
kubectl delete -f manifests/ --ignore-not-found=true

# Delete namespace (this will delete everything in it)
kubectl delete namespace ${NAMESPACE} --ignore-not-found=true

echo "✓ Cleanup completed"
