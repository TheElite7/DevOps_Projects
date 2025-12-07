#!/bin/bash

# From Browser
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml


# through Github clone
git clone https://github.com/kubernetes/ingress-nginx.git

# After Clone
kubectl apply -f /root/ingress-nginx/deploy/static/provider/cloud/deploy.yaml
kubectl get ns
kubectl -n ingress-nginx get pod -o wide
kubectl -n ingress-nginx get svc
