# Kubernetes Complete Guide

## Table of Contents

1. [Core Concepts](https://claude.ai/chat/3f6e79a4-da28-4bb9-88d6-e8bf56904a0a#core-concepts)
2. [Kubernetes Architecture](https://claude.ai/chat/3f6e79a4-da28-4bb9-88d6-e8bf56904a0a#kubernetes-architecture)
3. [Setup Instructions](https://claude.ai/chat/3f6e79a4-da28-4bb9-88d6-e8bf56904a0a#setup-instructions)
4. [kubectl and Core Components](https://claude.ai/chat/3f6e79a4-da28-4bb9-88d6-e8bf56904a0a#kubectl-and-core-components)

---

## Core Concepts

### 1. Monolithic vs Microservices Architecture

#### Monolithic Architecture

* **Definition** : A single deployable unit containing all application components
* **Characteristics** :
* Single codebase and deployment
* Shared database and runtime
* Tight coupling between components
* Easier to develop initially but harder to scale

#### Microservices Architecture

* **Definition** : Application broken down into small, independent services
* **Characteristics** :
* Multiple small services communicating via APIs
* Each service has its own database
* Independent deployment and scaling
* Technology diversity allowed
* Better fault isolation

#### Comparison Table

| Aspect                 | Monolithic               | Microservices              |
| ---------------------- | ------------------------ | -------------------------- |
| Deployment             | Single unit              | Multiple independent units |
| Scalability            | Scale entire application | Scale individual services  |
| Technology Stack       | Uniform                  | Diverse                    |
| Development Complexity | Lower initially          | Higher                     |
| Operational Complexity | Lower                    | Higher                     |
| Fault Tolerance        | Single point of failure  | Isolated failures          |

### 2. Why Kubernetes for Microservices?

* **Container Orchestration** : Manages containerized microservices
* **Service Discovery** : Automatic discovery of services
* **Load Balancing** : Distributes traffic across service instances
* **Auto-scaling** : Scales services based on demand
* **Health Monitoring** : Monitors and restarts failed services
* **Rolling Updates** : Zero-downtime deployments

---

## Kubernetes Architecture
![Kubernetes Architecture Diagram](https://miro.medium.com/v2/resize:fit:1400/1*0Sudxeu5mQyN3ahi1FV49A.png)

### Control Plane Components

#### 1. API Server (kube-apiserver)

* Central management entity
* Exposes Kubernetes API
* Handles all REST operations
* Entry point for all administrative tasks

#### 2. etcd

* Distributed key-value store
* Stores all cluster data
* Backup and disaster recovery critical
* Consistent and highly available

#### 3. Controller Manager (kube-controller-manager)

* Runs controller processes
* Node Controller: Manages node lifecycle
* Replication Controller: Maintains desired pod replicas
* Service Controller: Manages service endpoints

#### 4. Scheduler (kube-scheduler)

* Assigns pods to nodes
* Considers resource requirements
* Evaluates constraints and policies
* Optimizes resource utilization

### Node Components

#### 1. kubelet

* Primary node agent
* Communicates with API server
* Manages pod lifecycle
* Reports node and pod status

#### 2. kube-proxy

* Network proxy on each node
* Maintains network rules
* Handles load balancing
* Implements service abstraction

#### 3. Container Runtime

* Runs containers (Docker, containerd, CRI-O)
* Manages container lifecycle
* Implements Kubernetes CRI

### kubectl

* Command-line tool for Kubernetes
* Communicates with API server
* Manages cluster resources
* Supports YAML/JSON configurations

---

## Setup Instructions

### Local Setup

#### Windows

**Prerequisites:**

* Windows 10/11 with WSL2 enabled
* Docker Desktop installed

**Step-by-step installation:**

1. **Install Docker Desktop**
   ```bash
   # Download from https://www.docker.com/products/docker-desktop
   # Enable Kubernetes in Docker Desktop settings
   ```
2. **Install kubectl**
   ```powershell
   # Using Chocolatey
   choco install kubernetes-cli

   # Or using Scoop
   scoop install kubectl

   # Or download binary manually
   curl -LO "https://dl.k8s.io/release/v1.28.0/bin/windows/amd64/kubectl.exe"
   ```
3. **Install Minikube**
   ```powershell
   # Using Chocolatey
   choco install minikube

   # Or download binary
   curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-windows-amd64.exe
   move minikube-windows-amd64.exe minikube.exe
   ```
4. **Start Minikube**
   ```bash
   minikube start --driver=docker
   minikube status
   kubectl cluster-info
   ```

#### macOS

**Prerequisites:**

* macOS 10.15 or later
* Homebrew installed

**Step-by-step installation:**

1. **Install Docker Desktop**
   ```bash
   # Download from https://www.docker.com/products/docker-desktop
   # Enable Kubernetes in Docker Desktop settings
   ```
2. **Install kubectl**
   ```bash
   # Using Homebrew
   brew install kubectl

   # Or using curl
   curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/darwin/amd64/kubectl"
   chmod +x kubectl
   sudo mv kubectl /usr/local/bin/
   ```
3. **Install Minikube**
   ```bash
   # Using Homebrew
   brew install minikube

   # Or using curl
   curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-darwin-amd64
   sudo install minikube-darwin-amd64 /usr/local/bin/minikube
   ```
4. **Start Minikube**
   ```bash
   minikube start --driver=docker
   minikube status
   kubectl cluster-info
   ```

#### Linux (Ubuntu/Debian)

**Step-by-step installation:**

1. **Install Docker**
   ```bash
   # Update package index
   sudo apt update

   # Install Docker
   sudo apt install docker.io -y
   sudo systemctl start docker
   sudo systemctl enable docker
   sudo usermod -aG docker $USER
   ```
2. **Install kubectl**
   ```bash
   # Download kubectl
   curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

   # Make executable and move to PATH
   chmod +x kubectl
   sudo mv kubectl /usr/local/bin/

   # Verify installation
   kubectl version --client
   ```
3. **Install Minikube**
   ```bash
   # Download Minikube
   curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64

   # Install Minikube
   sudo install minikube-linux-amd64 /usr/local/bin/minikube
   ```
4. **Start Minikube**
   ```bash
   minikube start --driver=docker
   minikube status
   kubectl cluster-info
   ```

### Cloud Setup

#### AWS EC2

**Prerequisites:**

* AWS Account
* EC2 instance (t3.medium or larger recommended)
* Security group allowing ports 22, 6443, 8080

**Step-by-step installation:**

1. **Launch EC2 Instance**
   ```bash
   # Create EC2 instance with Ubuntu 22.04
   # Instance type: t3.medium (2 vCPU, 4 GB RAM minimum)
   # Security group: Allow SSH (22), HTTPS (443), Custom TCP (6443)
   ```
2. **Connect to Instance**
   ```bash
   ssh -i your-key.pem ubuntu@your-ec2-ip
   ```
3. **Install Docker**
   ```bash
   sudo apt update
   sudo apt install docker.io -y
   sudo systemctl start docker
   sudo systemctl enable docker
   sudo usermod -aG docker ubuntu
   ```
4. **Install kubectl**
   ```bash
   curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
   chmod +x kubectl
   sudo mv kubectl /usr/local/bin/
   ```
5. **Install kubeadm, kubelet**
   ```bash
   sudo apt update
   sudo apt install -y apt-transport-https ca-certificates curl

   curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-archive-keyring.gpg

   echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

   sudo apt update
   sudo apt install -y kubelet kubeadm kubectl
   sudo apt-mark hold kubelet kubeadm kubectl
   ```
6. **Initialize Kubernetes Cluster**
   ```bash
   sudo kubeadm init --pod-network-cidr=10.244.0.0/16

   # Configure kubectl
   mkdir -p $HOME/.kube
   sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
   sudo chown $(id -u):$(id -g) $HOME/.kube/config

   # Install CNI plugin (Flannel)
   kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml
   ```

#### Azure AKS

**Prerequisites:**

* Azure Account
* Azure CLI installed

**Step-by-step installation:**

1. **Install Azure CLI**
   ```bash
   # Windows
   Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi
   Start-Process msiexec.exe -ArgumentList '/I AzureCLI.msi /quiet' -Wait

   # macOS
   brew install azure-cli

   # Linux
   curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
   ```
2. **Login to Azure**
   ```bash
   az login
   ```
3. **Create Resource Group**
   ```bash
   az group create --name myResourceGroup --location eastus
   ```
4. **Create AKS Cluster**
   ```bash
   az aks create \
     --resource-group myResourceGroup \
     --name myAKSCluster \
     --node-count 2 \
     --node-vm-size Standard_DS2_v2 \
     --enable-addons monitoring \
     --generate-ssh-keys
   ```
5. **Configure kubectl**
   ```bash
   az aks get-credentials --resource-group myResourceGroup --name myAKSCluster
   ```
6. **Verify Cluster**
   ```bash
   kubectl get nodes
   kubectl cluster-info
   ```

#### Google Cloud Platform (GKE)

**Prerequisites:**

* GCP Account
* Google Cloud SDK installed

**Step-by-step installation:**

1. **Install Google Cloud SDK**
   ```bash
   # Windows
   # Download from https://cloud.google.com/sdk/docs/install

   # macOS
   brew install google-cloud-sdk

   # Linux
   curl https://sdk.cloud.google.com | bash
   exec -l $SHELL
   ```
2. **Initialize gcloud**
   ```bash
   gcloud init
   gcloud auth login
   gcloud config set project your-project-id
   ```
3. **Enable Required APIs**
   ```bash
   gcloud services enable container.googleapis.com
   gcloud services enable compute.googleapis.com
   ```
4. **Create GKE Cluster**
   ```bash
   gcloud container clusters create my-cluster \
     --zone us-central1-a \
     --num-nodes 2 \
     --machine-type e2-medium \
     --enable-autorepair \
     --enable-autoupgrade
   ```
5. **Configure kubectl**
   ```bash
   gcloud container clusters get-credentials my-cluster --zone us-central1-a
   ```
6. **Verify Cluster**
   ```bash
   kubectl get nodes
   kubectl cluster-info
   ```

---

## kubectl and Core Components

### kubectl Basic Commands

#### Cluster Information

```bash
# Get cluster info
kubectl cluster-info

# Get cluster version
kubectl version

# Get cluster nodes
kubectl get nodes

# Describe a node
kubectl describe node <node-name>
```

#### Configuration

```bash
# View current context
kubectl config current-context

# List all contexts
kubectl config get-contexts

# Switch context
kubectl config use-context <context-name>

# View configuration
kubectl config view
```

### Pods

#### What are Pods?

* Smallest deployable unit in Kubernetes
* Contains one or more containers
* Shared storage and network
* Atomic unit of scaling

#### Pod Operations

```bash
# Create a pod
kubectl run nginx-pod --image=nginx

# List pods
kubectl get pods
kubectl get pods -o wide

# Describe a pod
kubectl describe pod nginx-pod

# View pod logs
kubectl logs nginx-pod

# Execute command in pod
kubectl exec -it nginx-pod -- /bin/bash

# Delete a pod
kubectl delete pod nginx-pod
```

#### Pod YAML Example

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
  labels:
    app: nginx
spec:
  containers:
  - name: nginx
    image: nginx:1.21
    ports:
    - containerPort: 80
```

### Namespaces

#### What are Namespaces?

* Virtual clusters within a physical cluster
* Provide scope for names
* Resource quotas and policies
* Multi-tenancy support

#### Namespace Operations

```bash
# List namespaces
kubectl get namespaces
kubectl get ns

# Create namespace
kubectl create namespace dev
kubectl create ns prod

# Delete namespace
kubectl delete namespace dev

# Set default namespace
kubectl config set-context --current --namespace=dev

# Get resources in specific namespace
kubectl get pods -n kube-system
```

#### Namespace YAML Example

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: development
  labels:
    environment: dev
```

### Labels

#### What are Labels?

* Key-value pairs attached to objects
* Used for identification and selection
* Metadata for organization
* Enable grouping and filtering

#### Label Operations

```bash
# Add label to pod
kubectl label pod nginx-pod environment=production

# View labels
kubectl get pods --show-labels

# Filter by labels
kubectl get pods -l environment=production
kubectl get pods -l 'environment in (production,staging)'

# Remove label
kubectl label pod nginx-pod environment-
```

#### Label Examples

```yaml
metadata:
  labels:
    app: nginx
    version: v1.0
    environment: production
    tier: frontend
```

### Selectors

#### What are Selectors?

* Mechanism to select objects based on labels
* Used by controllers and services
* Equality-based and set-based

#### Selector Types

```bash
# Equality-based selectors
kubectl get pods -l environment=production
kubectl get pods -l environment!=production

# Set-based selectors
kubectl get pods -l 'environment in (production,staging)'
kubectl get pods -l 'environment notin (production,staging)'
kubectl get pods -l environment

# Multiple selectors
kubectl get pods -l app=nginx,environment=production
```

#### Selector in YAML

```yaml
# In Service
selector:
  app: nginx
  tier: frontend

# In Deployment
selector:
  matchLabels:
    app: nginx
  matchExpressions:
  - key: environment
    operator: In
    values: [production, staging]
```

### Annotations

#### What are Annotations?

* Non-identifying metadata
* Used by tools and libraries
* Cannot be used for selection
* Store arbitrary information

#### Annotation Operations

```bash
# Add annotation
kubectl annotate pod nginx-pod description="This is a test pod"

# View annotations
kubectl describe pod nginx-pod

# Remove annotation
kubectl annotate pod nginx-pod description-
```

#### Annotation Examples

```yaml
metadata:
  annotations:
    kubernetes.io/created-by: "user@example.com"
    deployment.kubernetes.io/revision: "1"
    description: "This pod runs the nginx web server"
    contact: "devops-team@company.com"
```

### Common kubectl Commands Cheat Sheet

#### Resource Management

```bash
# Apply configuration
kubectl apply -f deployment.yaml

# Create resource
kubectl create -f pod.yaml

# Replace resource
kubectl replace -f updated-pod.yaml

# Delete resource
kubectl delete -f pod.yaml
kubectl delete pod nginx-pod
```

#### Debugging

```bash
# Get events
kubectl get events

# Describe resource
kubectl describe pod nginx-pod

# View logs
kubectl logs nginx-pod
kubectl logs -f nginx-pod  # Follow logs

# Port forwarding
kubectl port-forward pod/nginx-pod 8080:80
```

#### Scaling and Updates

```bash
# Scale deployment
kubectl scale deployment nginx-deployment --replicas=3

# Rolling update
kubectl rollout status deployment/nginx-deployment
kubectl rollout history deployment/nginx-deployment
kubectl rollout undo deployment/nginx-deployment
```

---

## Best Practices

### 1. Resource Organization

* Use meaningful names for resources
* Implement consistent labeling strategy
* Organize resources with namespaces
* Use annotations for metadata

### 2. Security

* Use RBAC for access control
* Implement network policies
* Scan images for vulnerabilities
* Use secrets for sensitive data

### 3. Monitoring and Logging

* Implement health checks
* Monitor resource usage
* Centralize logging
* Set up alerting

### 4. High Availability

* Use multiple replicas
* Implement pod disruption budgets
* Use node affinity rules
* Plan for disaster recovery

---

## Troubleshooting

### Common Issues

1. **Pod stuck in Pending** : Check resource constraints
2. **ImagePullBackOff** : Verify image name and registry access
3. **CrashLoopBackOff** : Check application logs and health checks
4. **Network issues** : Verify service configuration and DNS

### Debugging Commands

```bash
# Check cluster health
kubectl get componentstatuses

# Check node resources
kubectl top nodes

# Check pod resources
kubectl top pods

# Get detailed events
kubectl get events --sort-by=.metadata.creationTimestamp
```

---

## Next Steps

1. Learn about Deployments and Services
2. Explore ConfigMaps and Secrets
3. Study Ingress and Load Balancing
4. Understand Persistent Volumes
5. Implement monitoring with Prometheus
6. Set up CI/CD pipelines
7. Learn about Helm package manager
8. Study advanced networking concepts

---

## Resources

* [Official Kubernetes Documentation](https://kubernetes.io/docs/)
* [kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
* [Kubernetes API Reference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.28/)
* [CNCF Kubernetes Certification](https://www.cncf.io/certification/cka/)
