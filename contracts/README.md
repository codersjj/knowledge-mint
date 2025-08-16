# KnowledgeMint 智能合约

## 📋 概述

KnowledgeMint 是一个基于区块链的去中心化知识分享平台，通过智能合约实现内容管理、奖励分发和反机器人保护等功能。

## 🏗️ 架构设计

### 核心合约

1. **KMToken.sol** - 平台代币合约 (ERC-20)
2. **ContentRegistry.sol** - 内容管理和元数据存储
3. **RewardCalculator.sol** - 动态奖励分发逻辑
4. **AntiBot.sol** - 反机器人保护和真实参与验证
5. **KnowledgeMint.sol** - 主平台合约，整合所有功能

### 合约关系图

```
KnowledgeMint (主合约)
    ├── KMToken (代币)
    ├── ContentRegistry (内容管理)
    ├── RewardCalculator (奖励计算)
    └── AntiBot (反机器人)
```

## 🚀 快速开始

### 环境要求

- Foundry (最新版本)
- Solidity 0.8.20+
- Node.js 18+

### 安装依赖

```bash
# 安装 Foundry
curl -L https://foundry.paradigm.xyz | bash
foundryup

# 安装 OpenZeppelin 合约
forge install OpenZeppelin/openzeppelin-contracts

# 安装其他依赖
forge install foundry-rs/forge-std
```

### 编译合约

```bash
# 编译所有合约
forge build

# 编译特定合约
forge build --contracts src/KnowledgeMint.sol
```

### 运行测试

```bash
# 运行所有测试
forge test

# 运行特定测试
forge test --match-test testPublishContent

# 运行测试并显示详细日志
forge test -vvv
```

### 部署合约

```bash
# 设置环境变量
cp .env.example .env
# 编辑 .env 文件，填入实际值

# 部署到本地网络
forge script script/Deploy.s.sol --rpc-url localhost --broadcast

# 部署到 Monad 测试网
forge script script/Deploy.s.sol --rpc-url $RPC_URL_MONAD_TESTNET --broadcast

# 部署到 Monad 主网
forge script script/Deploy.s.sol --rpc-url $RPC_URL_MONAD_MAINNET --broadcast
```

## 📝 合约功能详解

### KMToken.sol

**功能**: 平台代币管理

- 总供应量: 1 亿 KMT
- 分配: 60% 奖励池, 20% 团队, 20% 生态建设
- 支持暂停/恢复功能
- 仅奖励池可分发代币

**主要函数**:

- `distributeRewards()` - 分发奖励
- `setRewardPool()` - 设置奖励池地址
- `pause()/unpause()` - 暂停/恢复合约

### ContentRegistry.sol

**功能**: 内容管理和元数据存储

- 支持内容发布、更新、停用
- 记录阅读行为和评论
- IPFS 哈希存储
- 标签和分类管理

**主要函数**:

- `publishContent()` - 发布新内容
- `recordRead()` - 记录阅读行为
- `addComment()` - 添加评论
- `updateContent()` - 更新内容

### RewardCalculator.sol

**功能**: 动态奖励分发逻辑

- 基础阅读奖励: 5 KMT
- 完成阅读奖励: 10 KMT
- 质量奖励倍数: 最高 200%
- 时间奖励: 超过 5 分钟每分钟 1 KMT
- 每日奖励限制: 100 KMT

**主要函数**:

- `calculateAndDistributeRewards()` - 计算并分发奖励
- `submitQualityScore()` - 提交质量评分
- `getUserDailyRewards()` - 获取用户每日奖励

### AntiBot.sol

**功能**: 反机器人保护和真实参与验证

- 操作频率限制: 每日最多 100 次
- 操作间隔限制: 最少 30 秒
- 信誉分数系统: 1-100 分
- 自动黑名单机制

**主要函数**:

- `validateUserAction()` - 验证用户行为
- `recordUserAction()` - 记录用户行为
- `verifyUser()` - 验证用户身份
- `blacklistUser()` - 加入黑名单

### KnowledgeMint.sol

**功能**: 主平台合约，整合所有功能

- 统一的内容管理接口
- 集成的奖励分发系统
- 完整的反机器人保护
- 平台统计和用户数据

**主要函数**:

- `publishContent()` - 发布内容
- `readContent()` - 阅读内容
- `rateContent()` - 评分内容
- `addComment()` - 添加评论

## 🔧 配置说明

### foundry.toml

Foundry 配置文件，包含：

- Solidity 版本设置
- 优化器配置
- 依赖库映射
- RPC 端点配置

### 环境变量

创建 `.env` 文件并配置：

- `PRIVATE_KEY` - 部署者私钥
- `RPC_URL_MONAD_TESTNET` - Monad 测试网 RPC
- `RPC_URL_MONAD_MAINNET` - Monad 主网 RPC

## 🧪 测试

### 测试结构

```
test/
├── KMToken.t.sol      # 代币合约测试
├── ContentRegistry.t.sol # 内容管理测试
├── RewardCalculator.t.sol # 奖励计算测试
├── AntiBot.t.sol      # 反机器人测试
└── KnowledgeMint.t.sol # 主合约测试
```

### 运行测试

```bash
# 运行所有测试
forge test

# 运行特定测试文件
forge test --match-contract KMToken

# 运行测试并生成覆盖率报告
forge coverage
```

## 📊 Gas 优化

### 优化策略

1. **存储优化**: 使用紧凑的数据结构
2. **循环优化**: 避免无限循环和大量迭代
3. **事件优化**: 合理使用 indexed 参数
4. **函数优化**: 合并相似功能，减少调用次数

### Gas 报告

```bash
# 生成 Gas 报告
forge build --gas-report
```

## 🔐 安全特性

### 安全机制

1. **访问控制**: 使用 OpenZeppelin 的 Ownable 合约
2. **重入攻击防护**: 使用 ReentrancyGuard
3. **输入验证**: 严格的参数检查
4. **权限管理**: 细粒度的功能权限控制

### 审计准备

- 代码结构清晰，便于审计
- 完整的测试覆盖
- 详细的文档说明
- 符合 Solidity 最佳实践

## 🚀 部署流程

### 部署步骤

1. **准备环境**: 安装 Foundry，配置环境变量
2. **编译合约**: 使用 `forge build` 编译
3. **运行测试**: 使用 `forge test` 验证
4. **部署合约**: 使用部署脚本部署
5. **验证部署**: 检查合约地址和配置
6. **更新前端**: 将合约地址更新到前端配置

### 部署验证

部署完成后，验证：

- 所有合约地址正确
- 权限配置正确
- 初始状态正确
- 基本功能正常

## 📚 参考资源

- [Foundry Book](https://book.getfoundry.sh/)
- [OpenZeppelin Contracts](https://docs.openzeppelin.com/contracts/)
- [Solidity 文档](https://docs.soliditylang.org/)
- [Ethereum 开发指南](https://ethereum.org/developers/)

## 🤝 贡献指南

欢迎贡献代码！请遵循：

1. 代码风格一致
2. 添加适当的测试
3. 更新相关文档
4. 提交前运行测试

## 📄 许可证

本项目采用 MIT 许可证。
