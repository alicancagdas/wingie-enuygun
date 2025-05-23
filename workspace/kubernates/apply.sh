#!/bin/bash

set -e

echo "🔗 GKE cluster bağlantısı kuruluyor..."
gcloud container clusters get-credentials gke-cluster-demo \
  --region europe-west1-b \
  --project fiery-iridium-460518-m8

echo "🚀 Uygulama deploy ediliyor..."
kubectl apply -f deployment.yaml
kubectl apply -f hpa.yaml

echo "📊 HPA durumu:"
kubectl get hpa

echo "⏳ Lütfen biraz yük oluşturun ve scale durumunu izleyin:"
echo "  Örn: kubectl run -it --rm load-generator --image=busybox /bin/sh"
echo "  Ardından: while true; do wget -q -O- http://demo-app; done"
