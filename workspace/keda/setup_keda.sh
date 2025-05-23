#!/bin/bash

set -e

LOG_FILE="setup-keda.log"
NAMESPACE="keda"
RELEASE_NAME="keda"

echo "📦 KEDA Helm repo ekleniyor..." | tee "$LOG_FILE"
helm repo add kedacore https://kedacore.github.io/charts 2>&1 | tee -a "$LOG_FILE"
helm repo update 2>&1 | tee -a "$LOG_FILE"

echo "📁 Namespace ve KEDA kurulumu başlatılıyor..." | tee -a "$LOG_FILE"
helm install $RELEASE_NAME kedacore/keda --namespace $NAMESPACE --create-namespace 2>&1 | tee -a "$LOG_FILE"

echo "⏳ KEDA pod'larının hazır olması bekleniyor..." | tee -a "$LOG_FILE"
kubectl rollout status deployment/keda-operator -n $NAMESPACE 2>&1 | tee -a "$LOG_FILE"

echo "✅ KEDA kurulumu tamamlandı." | tee -a "$LOG_FILE"
echo "📊 Pod durumu:" | tee -a "$LOG_FILE"
kubectl get pods -n $NAMESPACE | tee -a "$LOG_FILE"

echo "📁 Log dosyası kaydedildi: $(pwd)/$LOG_FILE"
