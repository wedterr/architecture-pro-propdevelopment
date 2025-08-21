#!/bin/bash

developerUser="developer"
devopsUser="devops"
securityUser="security"

# Create users
cat <<EOF | kubectl apply -f -
    apiVersion: v1
    kind: ServiceAccount
    metadata:
      name: developer
      namespace: default
EOF

cat <<EOF | kubectl apply -f -
    apiVersion: v1
    kind: ServiceAccount
    metadata:
      name: devops
      namespace: default
EOF

cat <<EOF | kubectl apply -f -
    apiVersion: v1
    kind: ServiceAccount
    metadata:
      name: security
      namespace: default
EOF


# Create Roles and RoleBindings
# namespace-app-developer
cat <<EOF | kubectl apply -f -
    apiVersion: rbac.authorization.k8s.io/v1
    kind: Role
    metadata:
      namespace: default
      name: namespace-app-developer
    rules:
    - apiGroups: [""]
      resources: ["pods", "deployments", "statefulsets", "daemonsets", "replicasets", "jobs", "cronjobs", "services", "ingresses", "configmaps", "secrets", "persistentvolumeclaims", "events"]
      verbs: ["get", "list", "watch", "create", "update", "patch", "delete"]
EOF
cat <<EOF | kubectl apply -f -
    apiVersion: rbac.authorization.k8s.io/v1
    kind: RoleBinding
    metadata:
      name: namespace-app-developer-binding
      namespace: default
    subjects:
    - kind: User
      name: developer
      apiGroup: rbac.authorization.k8s.io
    roleRef:
      kind: Role
      name: namespace-app-developer
      apiGroup: rbac.authorization.k8s.io
EOF

# cluster-security-auditor
cat <<EOF | kubectl apply -f -
    apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRole
    metadata:
      namespace: default
      name: cluster-security-auditor
    rules:
    - apiGroups: [""]
      resources: ["*"]
      verbs: ["get", "list", "watch"]
EOF
cat <<EOF | kubectl apply -f -
    apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRoleBinding
    metadata:
      name: cluster-security-auditor-binding
      namespace: default
    subjects:
    - kind: User
      name: security
      apiGroup: rbac.authorization.k8s.io
    roleRef:
      kind: ClusterRole
      name: cluster-security-auditor
      apiGroup: rbac.authorization.k8s.io
EOF

# cluster-network-policy-manager
cat <<EOF | kubectl apply -f -
    apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRole
    metadata:
      namespace: default
      name: cluster-network-policy-manager
    rules:
    - apiGroups: [""]
      resources: ["networkpolicies"]
      verbs: ["get", "list", "watch", "create", "update", "patch", "delete"]
EOF
cat <<EOF | kubectl apply -f -
    apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRoleBinding
    metadata:
      name: cluster-network-policy-manager-binding
      namespace: default
    subjects:
    - kind: User
      name: security
      apiGroup: rbac.authorization.k8s.io
    roleRef:
      kind: ClusterRole
      name: cluster-network-policy-manager
      apiGroup: rbac.authorization.k8s.io
EOF

# cluster-infra-admin
cat <<EOF | kubectl apply -f -
    apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRole
    metadata:
      namespace: default
      name: cluster-infra-admin
    rules:
    - apiGroups: [""]
      resources: ["nodes", "namespaces", "storageclasses", "persistentvolumes", "csidrivers", "volumeattachments"]
      verbs: ["get", "list", "watch", "create", "update", "patch", "delete"]
EOF
cat <<EOF | kubectl apply -f -
    apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRoleBinding
    metadata:
      name: cluster-infra-admin-binding
      namespace: default
    subjects:
    - kind: User
      name: devops
      apiGroup: rbac.authorization.k8s.io
    roleRef:
      kind: ClusterRole
      name: cluster-infra-admin
      apiGroup: rbac.authorization.k8s.io
EOF

# cluster-app-deployer
cat <<EOF | kubectl apply -f -
    apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRole
    metadata:
      namespace: default
      name: cluster-app-deployer
    rules:
    - apiGroups: [""]
      resources: ["deployments", "statefulsets", "daemonsets", "replicasets", "jobs", "cronjobs", "services", "ingresses", "networkpolicies", "configmaps", "secrets", "persistentvolumeclaims", "events"]
      verbs: ["get", "list", "watch", "create", "update", "patch", "delete"]
EOF
cat <<EOF | kubectl apply -f -
    apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRoleBinding
    metadata:
      name: cluster-app-deployer-binding
      namespace: default
    subjects:
    - kind: User
      name: devops
      apiGroup: rbac.authorization.k8s.io
    roleRef:
      kind: ClusterRole
      name: cluster-app-deployer
      apiGroup: rbac.authorization.k8s.io
EOF

# cluster-debug-operator
cat <<EOF | kubectl apply -f -
    apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRole
    metadata:
      namespace: default
      name: cluster-debug-operator
    rules:
    - apiGroups: [""]
      resources: ["pods"]
      verbs: ["get", "list", "watch", "create", "delete"]
EOF
cat <<EOF | kubectl apply -f -
    apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRoleBinding
    metadata:
      name: cluster-debug-operator-binding
      namespace: default
    subjects:
    - kind: User
      name: devops
      apiGroup: rbac.authorization.k8s.io
    roleRef:
      kind: ClusterRole
      name: cluster-debug-operator
      apiGroup: rbac.authorization.k8s.io
EOF

# cluster-rbac-manager
cat <<EOF | kubectl apply -f -
    apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRole
    metadata:
      namespace: default
      name: cluster-rbac-manager
    rules:
    - apiGroups: [""]
      resources: ["roles", "rolebindings", "clusterroles", "clusterrolebindings", "serviceaccounts"]
      verbs: ["get", "list", "watch", "create", "delete", "update", "patch"]
EOF
cat <<EOF | kubectl apply -f -
    apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRoleBinding
    metadata:
      name: cluster-rbac-manager-binding
      namespace: default
    subjects:
    - kind: User
      name: devops
      apiGroup: rbac.authorization.k8s.io
    roleRef:
      kind: ClusterRole
      name: cluster-rbac-manager
      apiGroup: rbac.authorization.k8s.io
EOF