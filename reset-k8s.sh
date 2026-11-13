#!/bin/bash
echo "=== 重置 Kubernetes 節點環境 ==="
sudo kubeadm reset -f
sudo rm -rf /etc/cni/net.d "$HOME/.kube/config"
sudo iptables -F && sudo iptables -t nat -F && sudo iptables -t mangle -F && sudo iptables -X
echo "✅ 節點已重置完成。"
