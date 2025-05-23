#!/bin/bash

set -e
cd istio-1.26.0
export PATH=$PWD/bin:$PATH
cd ..
LOG_FILE="istio-mesh-test.log"
APP_NAME="demo-app"
NAMESPACE="default"

echo "🔍 Istio mesh test başlatılıyor..." | tee "$LOG_FILE"

# Label namespace
echo "🏷️ Namespace'e injection etiketi veriliyor..." | tee -a "$LOG_FILE"
kubectl label namespace $NAMESPACE istio-injection=enabled --overwrite | tee -a "$LOG_FILE"

# Uygulama yeniden başlatılıyor
echo "🔄 $APP_NAME yeniden başlatılıyor..." | tee -a "$LOG_FILE"
kubectl rollout restart deployment $APP_NAME -n $NAMESPACE | tee -a "$LOG_FILE"

# Pod'ların gelmesini bekle
echo "⏳ Pod'ların hazır olması bekleniyor..." | tee -a "$LOG_FILE"
sleep 10
kubectl wait --for=condition=ready pod -l app=demo -n $NAMESPACE --timeout=90s | tee -a "$LOG_FILE"

# Pod adı al
POD_NAME=$(kubectl get pods -n $NAMESPACE -l app=demo -o jsonpath="{.items[0].metadata.name}")

echo "📦 $POD_NAME pod içeriği inceleniyor..." | tee -a "$LOG_FILE"
CONTAINERS=$(kubectl get pod $POD_NAME -n $NAMESPACE -o jsonpath='{.spec.containers[*].name}')
echo "🔍 Container listesi: $CONTAINERS" | tee -a "$LOG_FILE"

# istio-proxy var mı?
if echo "$CONTAINERS" | grep -q "istio-proxy"; then
  echo "✅ Istio sidecar (istio-proxy) bulundu: Mesh aktif!" | tee -a "$LOG_FILE"
else
  echo "❌ Istio sidecar bulunamadı: Pod mesh içinde değil!" | tee -a "$LOG_FILE"
fi

# proxy-status (görsel kontrol)
echo "" | tee -a "$LOG_FILE"
echo "📊 istioctl proxy-status çıktısı:" | tee -a "$LOG_FILE"
istioctl proxy-status | tee -a "$LOG_FILE"

echo ""
echo "📁 Log dosyası: $(pwd)/$LOG_FILE"
