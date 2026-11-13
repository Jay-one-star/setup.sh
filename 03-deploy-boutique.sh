#!/bin/bash
set -e

echo "=== [1/3] 下載 Online Boutique 原始碼 ==="
if [ ! -d "microservices-demo" ]; then
    git clone --depth 1 --branch v0 https://github.com/GoogleCloudPlatform/microservices-demo.git
fi
cd microservices-demo

echo "=== [2/3] 部署所有微服務至 Kubernetes ==="
kubectl apply -f ./release/kubernetes-manifests.yaml

echo "=== [3/3] 等待所有 Pod 啟動完成（初次拉取映像檔約需 5~10 分鐘）==="
kubectl wait --for=condition=ready pod --all --timeout=900s

NODE_PORT=$(kubectl get service frontend-external -o jsonpath='{.spec.ports[0].nodePort}')
HOST_IP=$(hostname -I | awk '{print $1}')

echo ""
echo "=================================================================="
echo "🎉 Online Boutique 部署完成！"
echo "請在實體電腦瀏覽器開啟： http://${HOST_IP}:${NODE_PORT}"
echo "=================================================================="
