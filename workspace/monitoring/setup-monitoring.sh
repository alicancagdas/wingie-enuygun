#!/bin/bash

set -e

NAMESPACE="monitoring"
RELEASE_NAME="kps"

echo "📦 Helm repo ekleniyor..."
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

echo "📁 Namespace oluşturuluyor: $NAMESPACE"
kubectl create namespace $NAMESPACE --dry-run=client -o yaml | kubectl apply -f -

echo "🚀 Prometheus & Grafana kuruluyor..."
helm install $RELEASE_NAME prometheus-community/kube-prometheus-stack \
  -n $NAMESPACE \
  --set prometheus.prometheusSpec.maximumStartupDurationSeconds=300

echo "⏳ Grafana pod'u hazır olana kadar bekleniyor..."
kubectl rollout status deployment/${RELEASE_NAME}-grafana -n $NAMESPACE

echo "🔐 Grafana admin şifresi:"
kubectl get secret ${RELEASE_NAME}-grafana -n $NAMESPACE -o jsonpath="{.data.admin-password}" | base64 -d && echo

echo "🔧 Pod restart alarm kuralı uygulanıyor..."
kubectl apply -f pod-restart-alert.yaml

echo "📡 Port yönlendirme başlatılıyor (http://localhost:3000)..."
kubectl port-forward svc/${RELEASE_NAME}-grafana -n $NAMESPACE 3000:80 >/dev/null 2>&1 &
