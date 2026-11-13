#!/bin/bash
set -e

echo "=== [1/3] 初始化 Kubernetes Control Plane ==="
sudo kubeadm init --pod-network-cidr=10.244.0.0/16

echo "=== [2/3] 設定 kubectl 存取權限 ==="
mkdir -p "$HOME/.kube"
sudo cp -i /etc/kubernetes/admin.conf "$HOME/.kube/config"
sudo chown "$(id -u):$(id -g)" "$HOME/.kube/config"

echo "=== [3/3] 安裝 Flannel CNI 網路插件 ==="
kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml

echo ""
echo "=================================================================="
echo "✅ Master 初始化完成！請複製下方完整指令到 Worker 節點執行："
echo "=================================================================="
echo "sudo $(kubeadm token create --print-join-command)"
echo "=================================================================="
