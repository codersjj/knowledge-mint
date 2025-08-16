# 钱包连接设置指南

## 🚨 重要：设置环境变量

在运行应用之前，你需要设置以下环境变量：

### 1. 创建 .env.local 文件

在 `frontend` 目录下创建 `.env.local` 文件：

```bash
cd frontend
touch .env.local
```

### 2. 配置环境变量

编辑 `.env.local` 文件，添加以下内容：

```env
# WalletConnect Project ID (必需)
# 从 https://cloud.walletconnect.com/ 获取
NEXT_PUBLIC_WALLETCONNECT_PROJECT_ID=your_actual_project_id_here

# Monad 网络配置
NEXT_PUBLIC_MONAD_RPC_URL=https://rpc.testnet.monad.xyz

# 应用配置
NEXT_PUBLIC_APP_NAME=KnowledgeMint
NEXT_PUBLIC_APP_DESCRIPTION=Decentralized knowledge-sharing platform
NEXT_PUBLIC_APP_URL=http://localhost:3000
```

## 🔑 获取 WalletConnect Project ID

### 步骤 1：访问 WalletConnect Cloud

1. 打开 [https://cloud.walletconnect.com/](https://cloud.walletconnect.com/)
2. 使用 GitHub 账号登录

### 步骤 2：创建新项目

1. 点击 "Create New Project"
2. 输入项目名称：`KnowledgeMint`
3. 选择项目类型：`Web App`

### 步骤 3：获取 Project ID

1. 项目创建完成后，复制 Project ID
2. 将 Project ID 粘贴到 `.env.local` 文件中

## 🧪 测试钱包连接

### 1. 启动开发服务器

```bash
npm run dev
```

### 2. 访问应用

打开浏览器访问 `http://localhost:3000`

### 3. 测试连接

- 点击右上角的 "Connect Wallet" 按钮
- 选择 MetaMask 或其他支持的钱包
- 确认连接

## 🔧 故障排除

### 问题 1：ConnectButton 不显示

**可能原因**：

- 环境变量未设置
- WalletConnect Project ID 无效
- 网络配置错误

**解决方案**：

1. 检查 `.env.local` 文件是否存在
2. 验证 Project ID 是否正确
3. 重启开发服务器

### 问题 2：钱包连接失败

**可能原因**：

- 钱包未安装
- 网络不匹配
- 用户拒绝连接

**解决方案**：

1. 确保安装了 MetaMask 或其他支持的钱包
2. 检查钱包是否连接到正确的网络
3. 在钱包中确认连接请求

### 问题 3：控制台错误

**常见错误**：

```
Error: Invalid project id
Error: Failed to fetch
Error: Network error
```

**解决方案**：

1. 检查 Project ID 格式
2. 验证网络连接
3. 清除浏览器缓存

## 📱 支持的钱包

- **MetaMask** - 最流行的以太坊钱包
- **WalletConnect** - 多链钱包连接协议
- **Coinbase Wallet** - Coinbase 官方钱包
- **Trust Wallet** - Binance 官方钱包
- **其他支持 WalletConnect 的钱包**

## 🌐 网络配置

当前配置使用 Monad 测试网：

- **网络名称**: Monad Testnet
- **链 ID**: 10143
- **RPC URL**: https://rpc.testnet.monad.xyz
- **货币符号**: MONAD

## 🚀 下一步

钱包连接配置完成后：

1. 测试基本连接功能
2. 实现智能合约交互
3. 添加交易功能
4. 实现内容发布和奖励系统
