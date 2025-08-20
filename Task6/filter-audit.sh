jq 'select(.objectRef.resource=="secrets" and (.verb=="get" or .verb=="list"))' ./setup/audit.log > audit-extract.json

jq 'select(.verb=="create" and .objectRef.subresource=="exec")' ./setup/audit.log >> audit-extract.json

jq 'select(.objectRef.resource=="pods" and .requestObject.spec.containers[].securityContext.privileged==true)' ./setup/audit.log >> audit-extract.json

jq 'select((.objectRef.resource=="rolebindings" or .objectRef.resource=="clusterrolebindings") and .verb=="create" and .requestObject.roleRef.name=="cluster-admin")' ./setup/audit.log >> audit-extract.json

jq 'select(.verb=="delete")' ./setup/audit.log >> audit-extract.json