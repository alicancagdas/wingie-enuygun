#!/bin/bash

set -e

LOG_FILE="istio-install.log"

echo "🚀 Istio kurulumu başlatılıyor..." | tee "$LOG_FILE"

# Istio indir
curl -L https://istio.io/downloadIstio | sh - 2>&1 | tee -a "$LOG_FILE"

# En son indirilen istio klasörüne gir
ISTIO_DIR=$(ls -d istio-* | head -n 1)
cd "$ISTIO_DIR"

# PATH'e ekle
export PATH=$PWD/bin:$PATH

# Versiyon kontrolü
echo "🔍 Istio versiyonu:" | tee -a "$LOG_FILE"
istioctl version --remote=false | tee -a "$LOG_FILE"

# Istio kurulumu (demo profile)
echo "📦 Istio demo profili kuruluyor..." | tee -a "$LOG_FILE"
istioctl install --set profile=demo -y 2>&1 | tee -a "$LOG_FILE"

# Pod ve servisleri kontrol et
echo "⏳ Istio pod'ları kontrol ediliyor..." | tee -a "$LOG_FILE"
kubectl get pods -n istio-system | tee -a "$LOG_FILE"

echo "🔗 Istio servisleri:" | tee -a "$LOG_FILE"
kubectl get svc -n istio-system | tee -a "$LOG_FILE"

echo "✅ Istio kurulumu başarıyla tamamlandı." | tee -a "$LOG_FILE"
echo "📁 Log dosyası: $(pwd)/$LOG_FILE"
