# 📊 Kubernetes Monitoring Stack

Bu klasör, Kubernetes cluster'ı için Prometheus ve Grafana tabanlı monitoring stack'ini içerir.

## 🏗️ Monitoring Mimarisi

```mermaid
graph TB
    subgraph "Kubernetes Cluster"
        subgraph "Monitoring Namespace"
            P[Prometheus] --> AM[Alert Manager]
            P --> G[Grafana]
            
            subgraph "Metrics Flow"
                MS[Metrics Server] --> P
                NE[Node Exporter] --> P
                KSM[Kube State Metrics] --> P
            end
            
            subgraph "Visualization"
                G --> D1[System Dashboards]
                G --> D2[Pod Metrics]
                G --> D3[Node Metrics]
            end
            
            subgraph "Alerting"
                AM --> S1[Slack]
                AM --> S2[Email]
            end
        end
        
        subgraph "Application Pods"
            APP[Demo App] --> P
        end
    end

style P fill:#f96,stroke:#333
style G fill:#9cf,stroke:#333
style AM fill:#f9f,stroke:#333
style MS fill:#cfc,stroke:#333
```

## 📁 Dosya Yapısı

```
monitoring/
├── setup-monitoring.sh       # Ana kurulum scripti
├── pod-restart-alert.yaml   # Pod restart alert kuralı
├── grafana-gateway.yaml     # Grafana gateway tanımı
├── expose-grafana.sh        # Grafana expose scripti
└── setup.log               # Kurulum logları
```

## 🔄 Metrics Akışı

```mermaid
sequenceDiagram
    participant App as Application
    participant NE as Node Exporter
    participant P as Prometheus
    participant G as Grafana
    participant AM as Alert Manager
    
    App->>P: Pod Metrics
    NE->>P: Node Metrics
    P->>G: Metrics Query
    P->>AM: Alert Rules
    AM->>AM: Alert Evaluation
    G->>G: Dashboard Update
```

## 📈 Metrik Toplama

```mermaid
graph LR
    subgraph "Data Sources"
        NE[Node Exporter] --> P
        KSM[Kube State Metrics] --> P
        CE[Container Exporter] --> P
    end
    
    subgraph "Storage"
        P[Prometheus] --> TSB[Time Series DB]
    end
    
    subgraph "Visualization"
        TSB --> G[Grafana]
    end

style P fill:#f96
style G fill:#9cf
style TSB fill:#ff9
```

## ⚙️ Kurulum Bileşenleri

```
┌──────────────────────────────┐
│ Kube Prometheus Stack        │
├──────────────────────────────┤
│ ├─ Prometheus               │
│ ├─ Grafana                  │
│ ├─ Alert Manager            │
│ ├─ Node Exporter            │
│ └─ Kube State Metrics       │
└──────────────────────────────┘
```

## 🎯 Alert Kuralları

### Pod Restart Alert
```yaml
┌─────────────────────────────┐
│ Alert: PodRestarted         │
├─────────────────────────────┤
│ Condition: >2 restarts/5min │
│ Severity: Warning           │
│ Namespace: default          │
│ Target: demo-app pods       │
└─────────────────────────────┘
```

## 🔍 Grafana Dashboards

```mermaid
graph TB
    subgraph "Default Dashboards"
        D1[Kubernetes Cluster] --> M1[Node Metrics]
        D1 --> M2[Pod Metrics]
        D2[Resource Usage] --> M3[CPU/Memory]
        D2 --> M4[Network/Disk]
    end

style D1 fill:#9cf
style D2 fill:#9cf
```

## 📊 Metrik Örnekleri

### CPU Kullanımı
```
     CPU Usage
100% ┤
     │     Warning
 75% ┤     ╭──╮
     │     │  │
 50% ┤ ────╯  ╰────
     │
 25% ┤
     │
  0% ┤
     └─────────────────
        Time →
```

### Memory Kullanımı
```
     Memory Usage
8GB  ┤     ╭────╮
     │     │    │
6GB  ┤ ────╯    ╰──
     │
4GB  ┤
     │
2GB  ┤
     └─────────────────
        Time →
```

## 🔧 Kurulum Adımları

```mermaid
graph LR
    A[setup-monitoring.sh] -->|1| B[Helm Repo Add]
    B -->|2| C[Create Namespace]
    C -->|3| D[Install Stack]
    D -->|4| E[Setup Alerts]
    E -->|5| F[Configure Access]

style A fill:#f96
style F fill:#9cf
```

## 🔐 Erişim Yapılandırması

```mermaid
graph LR
    subgraph "Access Methods"
        P[Port Forward] --> L[localhost:3000]
        IG[Ingress] --> D[Domain]
        VS[Virtual Service] --> I[Istio Gateway]
    end

style P fill:#f96
style IG fill:#9cf
style VS fill:#f9f
```

## ⚡ Performans Metrikleri

### Prometheus
```
┌────────────────────┐
│ Retention: 15d     │
│ Scrape Interval: 1m│
│ Evaluation: 1m     │
└────────────────────┘
```

### Grafana
```
┌────────────────────┐
│ Refresh: 5s        │
│ Retention: 30d     │
│ Data Source: Prom  │
└────────────────────┘
```

## 📝 Önemli Komutlar

```bash
# Stack Durumu
kubectl -n monitoring get pods

# Grafana Şifresi
kubectl get secret kps-grafana \
  -n monitoring \
  -o jsonpath="{.data.admin-password}" \
  | base64 -d

# Port Forward
kubectl port-forward svc/kps-grafana \
  -n monitoring 3000:80
```
