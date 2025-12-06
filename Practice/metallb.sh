# To install MetalLB, apply the manifest:
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.15.3/config/manifests/metallb-native.yaml

# If you want to deploy MetalLB using the FRR mode, apply the manifests:
#kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.15.3/config/manifests/metallb-frr.yaml

# If you want to deploy MetalLB using the experimental FRR-K8s mode:
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.15.3/config/manifests/metallb-frr.yaml
