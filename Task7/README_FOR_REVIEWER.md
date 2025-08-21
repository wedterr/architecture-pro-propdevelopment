### Создайте namespace audit-zone с уровнем PodSecurity restricted.
```bash
kubectl apply -f 01-create-namespace.yaml
```

### Настройте OPA Gatekeeper с набором правил
```bash
kubectl apply -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper/v3.20.0/deploy/gatekeeper.yaml
kubectl apply -f ./gatekeeper/constraint-templates/
kubectl apply -f /gatekeeper/constraints/
```

### Проверить настройку PodSecurity Admission
```bash
sh ./verify/verify-admission.sh
```

### Проверить запуск secure и запрет insecure manifests
```bash
sh ./verify/validate-security.sh
```