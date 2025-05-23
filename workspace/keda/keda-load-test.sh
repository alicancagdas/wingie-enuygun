#!/bin/bash

set -e

LOG_FILE="keda-load-test.log"
DEPLOYMENT_NAME="demo-app"
NAMESPACE="default"

echo "🚀 KEDA Test Başlatılıyor..." | tee "$LOG_FILE"
echo "🕒 Başlangıç zamanı: $(date)" | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"

echo "📊 Başlangıç durumu:" | tee -a "$LOG_FILE"
kubectl get pods -l app=demo -o wide | tee -a "$LOG_FILE"
kubectl get scaledobject | tee -a "$LOG_FILE"
kubectl get hpa | tee -a "$LOG_FILE"
kubectl get nodes | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"

# Load-generator başlat
echo "🔥 Yük oluşturuluyor (Busybox sonsuz wget)..." | tee -a "$LOG_FILE"
kubectl run load-generator \
  --image=busybox \
  --restart=Never \
  -n "$NAMESPACE" \
  -- /bin/sh -c "while true; do wget -q -O- http://demo-app; done" &

# 🚀 4 node'a kadar yükle
echo "⏳ Node sayısı 4 olana kadar yük sürdürülüyor..." | tee -a "$LOG_FILE"

while true; do
  NODE_COUNT=$(kubectl get nodes --no-headers | wc -l)
  echo "📈 $(date) - Aktif node sayısı: $NODE_COUNT" | tee -a "$LOG_FILE"

  if [ "$NODE_COUNT" -ge 4 ]; then
    echo "🎯 4 node'a ulaşıldı, yük sonlandırılıyor..." | tee -a "$LOG_FILE"
    kubectl delete pod load-generator --ignore-not-found
    break
  fi

  sleep 30
done

# 📉 Scale-down: 2 node'a düşünceye kadar bekle
echo "⏳ Scale-down başlıyor: node sayısı 2'ye düşene kadar izleniyor..." | tee -a "$LOG_FILE"

while true; do
  NODE_COUNT=$(kubectl get nodes --no-headers | wc -l)
  echo "📉 $(date) - Aktif node sayısı: $NODE_COUNT" | tee -a "$LOG_FILE"

  if [ "$NODE_COUNT" -le 2 ]; then
    echo "✅ Node sayısı 2 veya altına düştü. Test tamamlandı!" | tee -a "$LOG_FILE"
    break
  fi

  sleep 30
done

echo "📁 Log dosyası: $(pwd)/$LOG_FILE"
