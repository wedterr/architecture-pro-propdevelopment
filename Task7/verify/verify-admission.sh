#!/bin/bash

echo "Verify cluster admission setup"
kubectl get namespace audit-zone -o yaml
kubectl get pods -n gatekeeper-system
kubectl get constrainttemplates
kubectl get constraints