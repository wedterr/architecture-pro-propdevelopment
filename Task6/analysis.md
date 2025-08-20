# Отчёт по результатам анализа Kubernetes Audit Log

## Подозрительные события

1. Доступ к секретам:
   - Кто: minikube-use
   - Где: kube-system namespace
   - Почему подозрительно: status 403 secrets is forbidden: User \"system:serviceaccount:secure-ops:monitoring\" cannot list resource \"secrets\" in API group \"\" in the namespace \"kube-system\" 

2. Привилегированные поды:
   - Кто: minikube-user
   - Комментарий: создание привилегированного пода с root правами, priveleged: true

3. Использование kubectl exec в чужом поде:
   - Кто: minikube-user
   - Что делал: Попытка заменить cat /etc/resolv.conf
   - exec failed: unable to start container process: exec: "cat": executable file not found in $PATH

4. Создание RoleBinding с правами cluster-admin:
   - Кто: minikube-user
   - К чему привело: Получение прав cluster-admin для сервис аккаунта system:serviceaccount:secure-ops:monitoring, аккаунт может выполнять любые операции в кластере

5. Удаление audit-policy.yaml:
   - Кто: admin
   - Возможные последствия: Отключение аудита, сокрытие получения неправомерного доступа
   - sh simulate-incedent.sh error: resource mapping not found for name: "" namespace: "" from "/etc/kubernetes/audit-policy.yaml": no matches for kind "Policy" in version "audit.k8s.io/v1"

## Вывод
Безопасность кластера под угрозой:
- Атакующий получил права cluster-admin
- Создан привилегированный под
- Была попытка убрать аудит и скрыть следы
- Часть атак из скрипта не прошли
- Необходимо пересоздать кластер, перепроверить права и роли, запретить содание привелегированных подов
