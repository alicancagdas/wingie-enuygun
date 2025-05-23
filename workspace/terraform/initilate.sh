
#!/bin/bash

set -e  # Hata olursa scripti durdur

echo "🌍 Terraform başlatılıyor..."
terraform init

echo "📦 Terraform plan hazırlanıyor..."
terraform plan -out=tfplan

echo "🚀 Terraform apply (infrastructure kuruluyor)..."
terraform apply -auto-approve tfplan

# output.tf ile cluster adını ve zone bilgisini export edebiliyorsanız daha iyi olur.
# Varsayalım vars.tf'den çekiyoruz:
CLUSTER_NAME=$(terraform output -raw cluster_name)
ZONE="europe-west1-b"
PROJECT_ID=$(terraform output -raw project_id)

echo "🔑 Kubectl için GKE kimlik bilgileri alınıyor..."
gcloud container clusters get-credentials $CLUSTER_NAME --zone $ZONE --project $PROJECT_ID

echo "✅ Kurulum tamamlandı!"
echo "🔍 Kontrol: GKE cluster ve node'lar:"
kubectl get nodes

echo "🔍 Pod’lar (başlangıçta boş olabilir):"
kubectl get pods --all-namespaces

