# 📊 Kubernetes Monitoring: Prometheus + Grafana Kurulumu

Bu proje, Kubernetes ortamında pod metriklerini izlemek ve **pod restart alarmı** kurmak için Prometheus ve Grafana’yı içerir.

---

## 📁 Dosya Yapısı

```
monitoring/
├\2500 setup-monitoring.sh         # Helm ile Prometheus + Grafana kurulumu
└\2500 pod-restart-alert.yaml      # Pod restartları için Prometheus alarm kuralı
```

---

## 🧰 Gereksinimler

* Helm yüklü (`helm version`)
* `kubectl` GKE cluster'a bağlı olmalı
* Cluster'da `kube-state-metrics` desteği olmalı (kube-prometheus-stack içindedir)

---

## 🚀 Kurulum

```bash
cd monitoring
chmod +x setup-monitoring.sh
./setup-monitoring.sh
```

### Script Ne Yapar?

1. Prometheus Helm chart'ını indirir
2. `monitoring` namespace'ini oluşturur
3. Prometheus + Grafana kurulumunu yapar
4. Grafana admin şifresini gösterir
5. `pod-restart-alert.yaml` ile PrometheusRule tanımlar
6. Grafana arayüzüne port yönlendirme başlatır (`http://localhost:3000`)

---

## 🔐 Grafana Girişi

* **Kullanıcı:** `admin`
* **Parola:** Script sonunda otomatik gösterilir

---

## 📁 Alarm Kuralı: `pod-restart-alert.yaml`

Pod restart sayısı 5 dakikada 2'den fazla olursa Prometheus alarm üretir:

```yaml
expr: increase(kube_pod_container_status_restarts_total[5m]) > 2
```

* Alarm 2 dakika boyunca devam ederse tetiklenir
* Uyarı `severity: warning` etiketiyle Alertmanager’a düşer

---

## 📊 İzleme Paneli

Grafana → Dashboards:

* `Kubernetes / Compute Resources / Namespace (Pods)`
* `Kubernetes / Networking / Pod`

---

## 📨 Alarmı Test Et

```bash
kubectl delete pod <pod-name>
kubectl delete pod <pod-name>
kubectl delete pod <pod-name>
```

Ya da özel bir pod oluşturup `CrashLoopBackOff` simülasyonu yapılabilir.

---

## 📬 İsteğe Bağlı

Alertmanager ile e-posta veya Slack bildirimi göndermek istersen:

* `values.yaml` içinde Alertmanager config yapılmalı
* Grafana Alerts kısmında Notification Channels tanımlanmalı

---

## ✨ Hazırlayan

Bu kurulum, GKE üzerinde autoscaling + metric izleme senaryosu içindir.
Pod restart metriklerini alarm düzeyinde izlemek isteyen tüm DevOps çalışanları için uygundur.
