minikube delete
minikube start
minikube stop
mkdir -p ~/.minikube/files/etc/ssl/certs
cat <<EOF > ~/.minikube/files/etc/ssl/certs/audit-policy.yaml
apiVersion: audit.k8s.io/v1
kind: Policy
rules:
  - level: RequestResponse
    verbs: ["create", "delete", "update", "patch", "get", "list"]
    resources:
      - group: ""
        resources: ["pods", "secrets", "configmaps", "serviceaccounts", "roles", "rolebindings"]
  - level: Metadata
    resources:
      - group: ""
        resources: ["*"]
EOF

minikube start --extra-config=apiserver.audit-policy-file=/etc/ssl/certs/audit-policy.yaml --extra-config=apiserver.audit-log-path=-
sh simulate-incedent.sh
kubectl logs kube-apiserver-minikube -n kube-system | grep audit.k8s.io/v1 > audit.log
