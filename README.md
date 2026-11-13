# k8s-online-boutique-vm

在本地 VMware 雙節點虛擬機（Ubuntu 22.04 Server：`master` / `worker`）一鍵自動化建置 Kubernetes (K8s) 叢集並部署 Google **Online Boutique** 微服務電商範例。

## 專案檔案結構
- `01-common-setup.sh`：關閉 Swap、設定核心網路模組、安裝 Containerd 與 `kubeadm` / `kubelet` / `kubectl`（**Master 與 Worker 兩台皆需執行**）
- `02-master-init.sh`：初始化 K8s Control Plane、設定 `kubectl` 權限、安裝 Flannel 網路插件，並輸出 `kubeadm join` 指令（**僅 Master 執行**）
- `03-deploy-boutique.sh`：下載 Online Boutique 原始碼、部署所有微服務 Pod，並顯示前端 `NodePort` 連線網址（**僅 Master 執行**）
- `reset-k8s.sh`：一鍵清空重來腳本（若安裝過程出錯欲重置叢集時使用）

---

## 快速開始（一鍵執行步驟）

### 0. 硬體規格確認（VM 關機狀態下調整）
- **Master**：至少 `2` 核心 CPU、`4 GB` RAM
- **Worker**：建議 `2~4` 核心 CPU、`6~8 GB` RAM

### 1. 下載此專案（Master 與 Worker 兩台皆執行）
```bash
git clone https://github.com/<你的帳號>/k8s-online-boutique-vm.git
cd k8s-online-boutique-vm
chmod +x *.sh
```

### 2. 安裝 K8s 基礎環境（Master 與 Worker 兩台皆執行）
```bash
sudo ./01-common-setup.sh
```

### 3. 初始化 Master 節點（僅 Master 執行）
```bash
./02-master-init.sh
```
> 執行完成後，終端機最下方會印出一行 **`sudo kubeadm join ...`** 指令，請複製該指令。

### 4. 將 Worker 加入叢集（僅 Worker 執行）
貼上步驟 3 複製的指令並執行：
```bash
sudo kubeadm join <MASTER_IP>:6443 --token <TOKEN> --discovery-token-ca-cert-hash sha256:<HASH>
```
回到 **Master** 執行 `kubectl get nodes`，確認 `master` 與 `worker` 的狀態皆變為 `Ready` 后再進行下一步。

### 5. 一鍵部署 Online Boutique（僅 Master 執行）
```bash
./03-deploy-boutique.sh
```
腳本會自動套用 YAML 並等待所有 Pod 啟動完成（約 5～10 分鐘），最後會直接印出可從本機瀏覽器開啟的 `http://<IP>:<Port>` 網址。
