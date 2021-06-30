#!/usr/bin/env bash

# Déploiement du pods:
kubectl apply -f config/myapi.pvnas.yml
kubectl apply -f config/myapi.pvcnas.yml
kubectl apply -f config/myapi.service.yml
kubectl apply -f config/myapi.deploy.yml
