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

echo "Deployment created successfully."

echo "Waiting 40 seconds..."
sleep 60

kubectl get all -o wide

# # Create the Service - ClusterIP
# cat > ser.yaml <<EOF
# apiVersion: v1
# kind: Service
# metadata:
#   name: websvc
#   labels:
#     app: portfolio
# spec:
#   selector:
#     app: portfolio
#   ports:
#     - name: httpd
#       port: 80
#       targetPort: 80
#   type: ClusterIP
# EOF

# kubectl create -f ser.yaml
# kubectl get svc -o wide


# Create the Service - NodePort
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
      nodePort: 31010   # NodePort is correctly defined
  type: NodePort        # Service type is NodePort
EOF


echo "Waiting 20 seconds..."
sleep 20

kubectl create -f ser.yaml
kubectl get svc -o wide
