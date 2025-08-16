# KnowledgeMint 🎓💰

**Knowledge is Currency. Learning is Earning.**

KnowledgeMint is a decentralized knowledge-sharing platform built on Monad blockchain, where users can publish educational content and earn tokens based on genuine reader engagement. By leveraging Monad's high throughput and low transaction costs, we enable micro-rewards for every meaningful interaction.

## 🌟 Features

### For Content Creators
- 📝 **Publish & Earn** - Upload tutorials, articles, and educational content
- 💎 **Quality Rewards** - Higher quality content receives boosted rewards
- 📊 **Analytics Dashboard** - Track your content performance and earnings
- 🏆 **Creator Reputation** - Build your expert status in the community

### For Learners
- 🔍 **Discover Knowledge** - Browse curated educational content across various topics
- 💰 **Read & Earn** - Get rewarded for genuine engagement with content
- 🎯 **Skill Verification** - Complete comprehension tests to unlock bonus rewards
- 🌐 **Community Interaction** - Ask questions, share insights, and collaborate

### Platform Features
- ⚡ **Instant Rewards** - Real-time token distribution powered by Monad
- 🛡️ **Anti-Bot Protection** - Advanced mechanisms to prevent fake engagement
- 🔗 **Decentralized Storage** - Content stored on IPFS for censorship resistance
- 📈 **Dynamic Pricing** - Smart contract-based reward calculation

## 🛠️ Tech Stack

### Frontend
- **Next.js 15** - React framework with App Router
- **Tailwind CSS** - Utility-first CSS framework
- **TypeScript** - Type-safe development
- **Wagmi** - React hooks for Ethereum
- **RainbowKit** - Wallet connection interface

### Backend & Smart Contracts
- **Solidity** - Smart contract development
- **Foundry** - Development toolkit for Ethereum applications
- **OpenZeppelin** - Security-focused contract libraries
- **IPFS** - Decentralized file storage

### Blockchain
- **Monad** - High-performance EVM-compatible blockchain
- **MetaMask** - Primary wallet integration

## 🚀 Quick Start

### Prerequisites
- Node.js 18+ 
- pnpm/npm/yarn
- Git
- Foundry

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/codersjj/knowledge-mint.git
cd knowledge-mint
```

2. **Install frontend dependencies**
```bash
cd frontend
npm install
```

3. **Install Foundry (for smart contracts)**
```bash
curl -L https://foundry.paradigm.xyz | bash
foundryup
```

4. **Install contract dependencies**
```bash
cd contracts
forge install
```

5. **Set up environment variables**
```bash
# Frontend (.env.local)
cp .env.example .env.local
# Edit with your API keys and contract addresses

# Contracts (.env)
cd contracts
cp .env.example .env
# Add your private key and RPC URLs
```

### Development

1. **Start the frontend development server**
```bash
cd frontend
npm run dev
```

2. **Deploy contracts (local)**
```bash
cd contracts
forge script script/Deploy.s.sol --rpc-url localhost --broadcast
```

3. **Run tests**
```bash
# Frontend tests
cd frontend && npm run test

# Contract tests
cd contracts && forge test
```

## 📋 Smart Contract Architecture

### Core Contracts

- **KnowledgeMint.sol** - Main platform contract
- **ContentRegistry.sol** - Content management and metadata
- **RewardCalculator.sol** - Dynamic reward distribution logic
- **AntiBot.sol** - Sybil resistance and genuine engagement verification
- **KMToken.sol** - Platform utility token (ERC-20)

### Key Functions

```solidity
// Publish new content
function publishContent(string calldata contentHash, bytes calldata metadata) external

// Record content interaction
function recordRead(uint256 contentId, bytes calldata proof) external

// Claim accumulated rewards
function claimRewards() external

// Verify content quality
function submitQualityScore(uint256 contentId, uint8 score, bytes calldata proof) external
```

## 🎨 UI/UX Design Principles

- **Minimalist** - Clean, distraction-free reading experience
- **Responsive** - Mobile-first design approach
- **Accessible** - WCAG 2.1 AA compliance
- **Fast** - Optimized for performance and quick interactions
- **Intuitive** - Easy onboarding for Web2 users new to Web3

## 🔐 Security Features

- **Multi-signature Admin** - Critical functions require multiple approvals
- **Time-locked Upgrades** - 48-hour delay for contract upgrades
- **Rate Limiting** - Prevent spam and abuse
- **Content Moderation** - Community-driven content curation
- **Audit Ready** - Code structured for professional security audits

## 🗓️ Roadmap

### Phase 1 - MVP (Current)
- [x] Basic smart contract architecture
- [x] Frontend UI framework
- [ ] Content publishing system
- [ ] Basic reward mechanism
- [ ] Wallet integration

### Phase 2 - Enhanced Features
- [ ] Advanced anti-bot protection
- [ ] Quality scoring algorithm
- [ ] Mobile app (React Native)
- [ ] Content categorization system

### Phase 3 - Community & Scale
- [ ] DAO governance token
- [ ] Creator monetization tools
- [ ] NFT certificates for course completion
- [ ] Multi-language support

### Phase 4 - Ecosystem
- [ ] API for third-party integrations
- [ ] Plugin system for custom content types
- [ ] Cross-chain bridge integration
- [ ] Enterprise partnerships

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

### Development Workflow
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🔗 Links

- **Website**: https://knowledgemint.app

## 💬 Support

- 🐛 Issues: [GitHub Issues](https://github.com/codersjj/knowledge-mint/issues)

---

**Built with ❤️ for the Monad Blitz Hackathon**

*Transforming knowledge into digital gold, one read at a time.*