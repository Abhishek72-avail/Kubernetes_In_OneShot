#!/bin/bash
# File: deploy.sh

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Configuration
NAMESPACE="web-app"
APP_NAME="web-app"
IMAGE_TAG=${1:-latest}

# Pre-deployment checks
pre_checks() {
    log "Running pre-deployment checks..."
    
    # Check if kubectl is available
    if ! command -v kubectl &> /dev/null; then
        error "kubectl is not installed"
        exit 1
    fi
    
    # Check cluster connectivity
    if ! kubectl cluster-info &> /dev/null; then
        error "Cannot connect to Kubernetes cluster"
        exit 1
    fi
    
    # Check if NGINX Ingress Controller is installed
    if ! kubectl get ingressclass nginx &> /dev/null; then
        warning "NGINX Ingress Controller not found, installing..."
        kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.1/deploy/static/provider/cloud/deploy.yaml
        log "Waiting for NGINX Ingress Controller to be ready..."
        kubectl wait --namespace ingress-nginx \
            --for=condition=ready pod \
            --selector=app.kubernetes.io/component=controller \
            --timeout=300s
    fi
    
    log "✓ Pre-checks completed"
}

# Build Docker image
build_image() {
    log "Building Docker image..."
    
    cd app/
    docker build -t ${APP_NAME}:${IMAGE_TAG} .
    
    # If using local registry
    if command -v kind &> /dev/null; then
        log "Loading image to kind cluster..."
        kind load docker-image ${APP_NAME}:${IMAGE_TAG}
    fi
    
    cd ../
    log "✓ Image built successfully"
}

# Deploy application
deploy_app() {
    log "Deploying application to Kubernetes..."
    
    # Apply manifests in order
    kubectl apply -f manifests/namespace.yaml
    kubectl apply -f manifests/configmap.yaml
    kubectl apply -f manifests/secret.yaml
    kubectl apply -f manifests/deployment.yaml
    kubectl apply -f manifests/service.yaml
    kubectl apply -f manifests/ingress.yaml
    kubectl apply -f manifests/hpa.yaml
    
    log "✓ Manifests applied"
}

# Wait for deployment
wait_for_deployment() {
    log "Waiting for deployment to be ready..."
    
    kubectl wait --for=condition=available --timeout=10s \
        deployment/${APP_NAME}-deployment -n ${NAMESPACE}
    
    # Wait for pods to be ready
    kubectl wait --for=condition=ready --timeout=10s \
        pod -l app=${APP_NAME} -n ${NAMESPACE}
    
    log "✓ Deployment is ready"
}

# Health check
health_check() {
    log "Performing health check..."
    
    # Get service info
    kubectl get svc -n ${NAMESPACE}
    kubectl get ingress -n ${NAMESPACE}
    
    # Port forward for testing (if no external IP)
    log "Setting up port forwarding for testing..."
    kubectl port-forward -n ${NAMESPACE} svc/${APP_NAME}-service 8080:80 &
    PORT_FORWARD_PID=$!
    
    sleep 5
    
    # Test application
    if curl -f http://localhost:8080/health >/dev/null 2>&1; then
        log "✓ Application health check passed"
    else
        error "✗ Application health check failed"
        kill $PORT_FORWARD_PID 2>/dev/null || true
        exit 1
    fi
    
    kill $PORT_FORWARD_PID 2>/dev/null || true
}

# Main deployment function
main() {
    log "Starting deployment of ${APP_NAME}..."
    
    pre_checks
    build_image
    deploy_app
    wait_for_deployment
    health_check
    
    log "🎉 Deployment completed successfully!"
    log ""
    log "Application URLs:"
    log "  Health Check: http://localhost:8080/health"
    log "  API Endpoint: http://localhost:8080/api/users"
    log ""
    log "Useful commands:"
    log "  kubectl get pods -n ${NAMESPACE}"
    log "  kubectl logs -f deployment/${APP_NAME}-deployment -n ${NAMESPACE}"
    log "  kubectl describe ingress ${APP_NAME}-ingress -n ${NAMESPACE}"
}

# Run main function
main "$@"
