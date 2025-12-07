#!/bin/bash

# Pull the image
docker pull theberu/practice:v2


# image show
docker images


# Run the container
docker run -d --name website -p 8080:80 theberu/practice:v2


# Write deployment YAML to file
cat > deploy.yaml <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: deployweb
  labels:
    app: portfolio
spec:
  replicas: 5
  selector:
    matchLabels:
      app: portfolio
  template:
    metadata:
      labels:
        app: portfolio
    spec:
      containers:
        - name: portfo-cont
          image: theberu/practice:v2
EOF

# Apply deployment
kubectl apply -f deploy.yaml

echo " Deployment Creating Wait for 30 seconds...Waiting 30 seconds... "
sleep 30

kubectl get all -o wide


# instsall metalb for loadbalancing
echo " configuring Local Loadbalancer... "
sleep 10
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.15.3/config/manifests/metallb-frr.yaml


# Create the ClusterIP Service
cat > ser.yaml <<EOF
apiVersion: v1
kind: Service
metadata:
  name: websvc
  labels:
    app: portfolio
spec:
  selector:
    app: portfolio
  ports:
    - name: httpd
      port: 80
      targetPort: 80
  type: ClusterIP
EOF

kubectl create -f ser.yaml
kubectl get svc -o wide


# Install the ingress controller setup
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml
echo"Ingress controller installing..."
sleep 15

kubectl get ns
kubectl -ns ingress-nginx get svc -o wide


# Create the Ingress Controller
cat > ing.yaml <<EOF
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: portfolio-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - host: portfolio.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: websvc
            port:
              number: 80
EOF

kubectl create -f ing.yaml
kubectl get ingress -o wide
kubectl get all -o wide
