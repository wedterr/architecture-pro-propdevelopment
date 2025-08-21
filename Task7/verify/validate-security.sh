echo "Applying insecure manifests"
kubectl apply -f insecure-manifests/01-privileged-pod.yaml --dry-run=server
kubectl apply -f insecure-manifests/02-hostpath-pod.yaml --dry-run=server
kubectl apply -f insecure-manifests/03-root-user-pod.yaml --dry-run=server
echo "======================================================"
echo "Applying secure manifests"
kubectl apply -f secure-manifests/01-secure.yaml --dry-run=server
kubectl apply -f secure-manifests/02-secure.yaml --dry-run=server
kubectl apply -f secure-manifests/03-secure.yaml --dry-run=server