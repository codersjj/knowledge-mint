# KnowledgeMint 智能合约 Makefile

.PHONY: help install build test deploy clean

# 默认目标
help:
	@echo "KnowledgeMint 智能合约管理"
	@echo ""
	@echo "可用命令:"
	@echo "  install    - 安装依赖"
	@echo "  build      - 编译合约"
	@echo "  test       - 运行测试"
	@echo "  deploy     - 部署合约"
	@echo "  clean      - 清理构建文件"
	@echo "  coverage   - 生成测试覆盖率报告"
	@echo "  gas-report - 生成 Gas 报告"
	@echo "  lint       - 代码检查"
	@echo "  format     - 代码格式化"

# 安装依赖
install:
	@echo "安装 OpenZeppelin 合约..."
	forge install OpenZeppelin/openzeppelin-contracts
	@echo "安装 Forge Standard Library..."
	forge install foundry-rs/forge-std
	@echo "依赖安装完成!"

# 编译合约
build:
	@echo "编译智能合约..."
	forge build
	@echo "编译完成!"

# 运行测试
test:
	@echo "运行测试..."
	forge test

# 运行测试（详细输出）
test-verbose:
	@echo "运行测试（详细输出）..."
	forge test -vvv

# 运行特定测试
test-match:
	@echo "运行匹配的测试..."
	forge test --match-test $(TEST)

# 部署合约（本地）
deploy-local:
	@echo "部署到本地网络..."
	forge script script/Deploy.s.sol --rpc-url localhost --broadcast

# 部署合约（Monad 测试网）
deploy-testnet:
	@echo "部署到 Monad 测试网..."
	forge script script/Deploy.s.sol --rpc-url $(RPC_URL) --broadcast

# 部署合约（Monad 主网）
deploy-mainnet:
	@echo "部署到 Monad 主网..."
	forge script script/Deploy.s.sol --rpc-url $(RPC_URL) --broadcast

# 清理构建文件
clean:
	@echo "清理构建文件..."
	forge clean
	@echo "清理完成!"

# 生成测试覆盖率报告
coverage:
	@echo "生成测试覆盖率报告..."
	forge coverage
	@echo "覆盖率报告生成完成!"

# 生成 Gas 报告
gas-report:
	@echo "生成 Gas 报告..."
	forge build --gas-report
	@echo "Gas 报告生成完成!"

# 代码检查
lint:
	@echo "检查代码..."
	forge build --sizes
	@echo "代码检查完成!"

# 代码格式化
format:
	@echo "格式化代码..."
	forge fmt
	@echo "代码格式化完成!"

# 验证合约
verify:
	@echo "验证合约..."
	forge verify-contract $(CONTRACT_ADDRESS) $(CONTRACT_NAME) --chain-id $(CHAIN_ID)

# 启动本地节点
anvil:
	@echo "启动本地 Anvil 节点..."
	anvil

# 运行特定测试并显示 Gas 使用
test-gas:
	@echo "运行测试并显示 Gas 使用..."
	forge test --gas-report

# 运行模糊测试
fuzz:
	@echo "运行模糊测试..."
	forge test --fuzz-runs 10000

# 运行不变性测试
invariant:
	@echo "运行不变性测试..."
	forge test --invariant-runs 1000

# 显示合约大小
size:
	@echo "显示合约大小..."
	forge build --sizes

# 安装特定版本的依赖
install-version:
	@echo "安装特定版本的依赖..."
	forge install OpenZeppelin/openzeppelin-contracts@v5.0.0
	forge install foundry-rs/forge-std@v1.7.1

# 更新依赖
update:
	@echo "更新依赖..."
	forge update
	@echo "依赖更新完成!"

# 显示依赖树
deps:
	@echo "显示依赖树..."
	forge remappings > remappings.txt
	@echo "依赖映射已保存到 remappings.txt"

# 运行基准测试
benchmark:
	@echo "运行基准测试..."
	forge test --gas-report --fuzz-runs 1000 --invariant-runs 1000

# 部署并验证
deploy-and-verify:
	@echo "部署并验证合约..."
	$(MAKE) deploy-testnet
	@echo "等待部署确认..."
	sleep 10
	$(MAKE) verify

# 显示帮助信息
help-detailed:
	@echo "KnowledgeMint 智能合约详细帮助"
	@echo ""
	@echo "环境变量:"
	@echo "  PRIVATE_KEY          - 部署者私钥"
	@echo "  RPC_URL             - RPC 端点 URL"
	@echo "  ETHERSCAN_API_KEY   - Etherscan API 密钥"
	@echo ""
	@echo "示例用法:"
	@echo "  make deploy-testnet RPC_URL=https://rpc.testnet.monad.xyz"
	@echo "  make test-match TEST=testPublishContent"
	@echo "  make verify CONTRACT_ADDRESS=0x... CONTRACT_NAME=KnowledgeMint CHAIN_ID=1337" 