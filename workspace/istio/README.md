# 🌐 Istio Service Mesh

Bu klasör, Kubernetes cluster'ı için Istio service mesh kurulumu ve test sonuçlarını içerir.

## 🏗️ Istio Mimarisi

```mermaid
graph TB
    subgraph "Kubernetes Cluster"
        subgraph "Control Plane"
            IS[Istiod] --> D[Discovery]
            IS --> V[Validation]
            IS --> C[CA/Auth]
        end
        
        subgraph "Data Plane"
            IG[Ingress Gateway] --> P1[Proxy]
            EG[Egress Gateway] --> P2[Proxy]
            
            subgraph "Application Pods"
                A1[App Container] --> SP1[Sidecar Proxy]
                A2[App Container] --> SP2[Sidecar Proxy]
            end
        end
        
        IS -.-> SP1
        IS -.-> SP2
        IS -.-> P1
        IS -.-> P2
    end

style IS fill:#f96,stroke:#333
style IG fill:#9cf,stroke:#333
style EG fill:#f9f,stroke:#333
style SP1 fill:#cfc,stroke:#333
style SP2 fill:#cfc,stroke:#333
```

## 📁 Dosya Yapısı

```
istio/
├── isito_setup.sh         # Kurulum scripti
├── istio-install.log     # Kurulum logları
├── istio-mesh-test.sh   # Mesh test scripti
├── istio-mesh-test.log # Test sonuçları
└── istio-1.26.0/      # Istio binary ve örnekler
```

## 🔄 Sidecar Injection Mekanizması

```mermaid
sequenceDiagram
    participant NS as Namespace
    participant API as API Server
    participant W as Webhook
    participant P as Pod
    participant S as Sidecar
    
    NS->>API: Label: istio-injection=enabled
    API->>W: Pod Creation Request
    W->>W: Inject Sidecar Config
    W->>P: Create Pod with Sidecar
    P->>S: Initialize Sidecar
    Note over S: Proxy Started
```

## 📊 Mesh Topolojisi

```mermaid
graph LR
    subgraph "Service Mesh"
        IG[Ingress Gateway] --> P1[Proxy]
        P1 --> A1[App v1]
        P1 --> A2[App v2]
        
        A1 --> P2[Proxy]
        A2 --> P2
        P2 --> EG[Egress Gateway]
    end
    
    subgraph "Control"
        I[Istiod] -.-> P1
        I -.-> P2
    end

style IG fill:#f96
style EG fill:#9cf
style I fill:#f9f
```

## ⚙️ Kurulum Bileşenleri

```yaml
┌──────────────────────────────┐
│ Istio Components (v1.26.0)   │
├──────────────────────────────┤
│ ├─ istiod                   │
│ ├─ ingress-gateway          │
│ ├─ egress-gateway          │
│ └─ sidecar-injector        │
└──────────────────────────────┘
```

## 🔍 Test Sonuçları

### Proxy Senkronizasyon Durumu
```
┌─────────────┬─────────┬────────┐
│ Component   │ Status  │ Time   │
├─────────────┼─────────┼────────┤
│ CDS         │ SYNCED  │ 5s     │
│ LDS         │ SYNCED  │ 5s     │
│ EDS         │ SYNCED  │ 5s     │
│ RDS         │ SYNCED  │ 5s     │
│ ECDS        │ IGNORED │ -      │
└─────────────┴─────────┴────────┘
```

### Sidecar Durumu
```
     Injection Success
100% ┤ ██████████
 80% ┤ 
 60% ┤ 
 40% ┤ 
 20% ┤ 
  0% ┤ 
     └─────────────
```

## 🔄 Kurulum Akışı

```mermaid
graph LR
    A[isito_setup.sh] -->|1| B[Download Istio]
    B -->|2| C[Install Binaries]
    C -->|3| D[Deploy Control Plane]
    D -->|4| E[Enable Injection]
    
    style A fill:#f96
    style E fill:#9cf
```

## 📈 Performans Metrikleri

### Başlangıç Süreleri
```
Component Start Times
     ┤
Proxy ┤ ████  2s
     ┤
App   ┤ ██████  3s
     ┤
Mesh  ┤ ████████  4s
     ┤
     └─────────────
        Time (seconds)
```

## 🎯 Test Senaryosu

```mermaid
stateDiagram-v2
    [*] --> Setup
    Setup --> Injection
    Injection --> Validation
    Validation --> Proxy
    Proxy --> Sync
    Sync --> [*]
    
    note right of Injection: Enable namespace
    note right of Validation: Check sidecar
    note right of Proxy: Verify status
```

## ⚡ Sistem Durumu

### Control Plane
```
┌────────────────────────┐
│ Control Plane Status   │
├────────────────────────┤
│ ├─ istiod: Running    │
│ ├─ Version: 1.26.0    │
│ ├─ Pods: 1/1          │
│ └─ Health: ✅         │
└────────────────────────┘
```

### Data Plane
```
┌────────────────────────┐
│ Data Plane Status      │
├────────────────────────┤
│ ├─ Proxies: Synced    │
│ ├─ Gateways: 2/2      │
│ ├─ Services: Healthy  │
│ └─ Latency: <1ms      │
└────────────────────────┘
```

## 🔧 Kullanım

1. **Kurulum**
   ```bash
   ./isito_setup.sh
   ```

2. **Mesh Testi**
   ```bash
   ./istio-mesh-test.sh
   ```

## 📝 Önemli Notlar

1. **Kurulum**
   - Istio version: 1.26.0
   - Profile: demo
   - Auto-injection aktif

2. **Güvenlik**
   - mTLS aktif
   - Authorization policies yapılandırılabilir
   - Service-to-service authentication

3. **İzleme**
   - Proxy senkronizasyonu
   - Service mesh topolojisi
   - Sidecar durumu

## ✅ Doğrulama Sonuçları

Test sonuçları, sistemin şu özelliklere sahip olduğunu gösteriyor:

1. **Kurulum Başarısı**
   - Control plane aktif
   - Sidecar injection çalışıyor
   - Gateways hazır

2. **Mesh Entegrasyonu**
   - Proxy senkronize
   - Service discovery aktif
   - Load balancing çalışıyor

3. **Sistem Sağlığı**
   - Tüm bileşenler senkronize
   - Düşük latency
   - Stabil operasyon 