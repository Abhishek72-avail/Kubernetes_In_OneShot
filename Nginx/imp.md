## 🔧 Steps to Fix
✅ 1. Check current kubectl context
- Run: kubectl config current-context

✅ 2. List all available contexts
- Run : kubectl config get-contexts

## Look for one that points to a valid cluster.

✅ 3. Switch to a working context (example: minikube)
- Run: kubectl config use-context minikube

## 🛠️ If you're using Minikube or Kind:
➤ For Minikube, restart it:
- Run: minikube start

➤ For Kind, recreate your cluster:
- Run:kind create cluster

## 🧼 Optional: Remove the broken context (only if you’re sure)

- kubectl config delete-context <context-name>
- kubectl config unset clusters.<cluster-name>
- kubectl config unset users.<user-name>

## 🧪 Example fix (Minikube):

- minikube start
- kubectl config use-context minikube
- kubectl get nodes

# This should restore access and fix the connection refused error.

