#!/bin/bash
set -e
LOG="grafana-ingress.log"

echo "🚀 Istio üzerinden Grafana erişimi kuruluyor..." | tee $LOG

echo "📁 YAML dosyaları uygulanıyor..." | tee -a $LOG
kubectl apply -f grafana-gateway.yaml | tee -a $LOG
kubectl apply -f grafana-virtualservice.yaml | tee -a $LOG

echo "🌐 Dış IP alınıyor..." | tee -a $LOG
INGRESS_IP=$(kubectl get svc istio-ingressgateway -n istio-system -o jsonpath="{.status.loadBalancer.ingress[0].ip}")

echo "" | tee -a $LOG
echo "✅ Başarılı! Grafana'ya şu adresten ulaşabilirsin:" | tee -a $LOG
echo "🔗 http://$INGRESS_IP/grafana" | tee -a $LOG

echo "" | tee -a $LOG
echo "🔐 Admin şifresi:" | tee -a $LOG
kubectl get secret kps-grafana -n monitoring -o jsonpath="{.data.admin-password}" | base64 -d && echo
