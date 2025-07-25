# Kubernetes Ingress Guide

## Ingress kya hai?

Ingress ek Kubernetes object hai jo cluster ke bahar se aane wale HTTP/HTTPS traffic ko andar ke services tak route karta hai.

Aap ise ek smart gatekeeper ya router samajh sakte ho — jo decide karta hai ki kaunsa request kahan jaana chahiye.

## 🔹 Ingress kyun use karte hain?

### ✅ 1. Single Entry Point
Agar aapke paas multiple services hain (frontend, backend, etc.), to har ek ke liye NodePort ya LoadBalancer use karna inefficient hai.

➡️ Ingress ek hi domain/IP ke through multiple services ko access karne deta hai.

### ✅ 2. Path ya Host-based Routing
Ingress rules allow karte hain:
- `example.com/api` → backend service
- `example.com/web` → frontend service
- `api.example.com` → backend
- `admin.example.com` → admin panel

Yeh aap path ya hostname ke base par define kar sakte ho.

### ✅ 3. SSL / HTTPS Support
Ingress easily HTTPS setup karne deta hai (TLS termination), jisse aapki app secure ho jati hai.

### ✅ 4. Central Configuration
Sabhi routing rules, SSL config, aur access controls ek hi jagah se manage kar sakte ho.

### ✅ 5. Advanced Features (NGINX Ingress Controller ke saath):
- Basic authentication
- Rate limiting
- IP whitelisting
- Custom error pages

## 🔹 Real-world Example:

Aapke paas 3 services hain:
- Frontend
- Backend
- Admin

Aap Ingress me rule set karte ho:

```yaml
rules:
  - host: myapp.com
    http:
      paths:
        - path: /frontend
          backend:
            service: frontend-service
        - path: /backend
          backend:
            service: backend-service
        - path: /admin
          backend:
            service: admin-service
```

➡️ Ab `myapp.com/frontend` se frontend open hoga, `myapp.com/backend` se backend.

## 🔹 Summary (Ek line mein):
Ingress use karte hain taaki multiple services ko ek hi domain/IP se easily aur securely access kar sakein, with routing and HTTPS support.