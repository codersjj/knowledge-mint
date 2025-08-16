# KnowledgeMint Frontend Setup

## Prerequisites

- Node.js 18+
- npm, yarn, or pnpm
- Git

## Installation

1. **Install dependencies**

```bash
npm install
```

2. **Create environment file**

```bash
cp .env.example .env.local
```

3. **Configure environment variables**
   Edit `.env.local` with your configuration:

```env
# WalletConnect Project ID
NEXT_PUBLIC_WALLETCONNECT_PROJECT_ID=your_walletconnect_project_id_here

# Monad RPC URL
NEXT_PUBLIC_MONAD_RPC_URL=https://rpc.monad.xyz

# Contract Addresses (to be deployed)
NEXT_PUBLIC_KNOWLEDGE_MINT_CONTRACT_ADDRESS=
NEXT_PUBLIC_KMT_TOKEN_CONTRACT_ADDRESS=
NEXT_PUBLIC_CONTENT_REGISTRY_CONTRACT_ADDRESS=

# IPFS Configuration
NEXT_PUBLIC_IPFS_GATEWAY=https://ipfs.io/ipfs/
NEXT_PUBLIC_IPFS_API_URL=https://ipfs.infura.io:5001/api/v0

# App Configuration
NEXT_PUBLIC_APP_NAME=KnowledgeMint
NEXT_PUBLIC_APP_DESCRIPTION=Decentralized knowledge-sharing platform
NEXT_PUBLIC_APP_URL=http://localhost:3000
```

## Development

1. **Start development server**

```bash
npm run dev
```

2. **Open browser**
   Navigate to [http://localhost:3000](http://localhost:3000)

## Build

1. **Build for production**

```bash
npm run build
```

2. **Start production server**

```bash
npm start
```

## Features

- **Home Page**: Landing page with hero section and features
- **Browse Page**: Content discovery with search and filters
- **Publish Page**: Content creation and publishing form
- **Dashboard**: Creator analytics and content management
- **Navigation**: Responsive navigation with wallet connection
- **Wallet Integration**: RainbowKit + Wagmi for Web3 functionality

## Tech Stack

- Next.js 15 with App Router
- TypeScript
- Tailwind CSS
- RainbowKit for wallet connection
- Wagmi for Ethereum interactions
- Lucide React for icons

## Project Structure

```
src/
├── app/
│   ├── browse/          # Content browsing page
│   ├── dashboard/       # Creator dashboard
│   ├── publish/         # Content publishing
│   ├── layout.tsx      # Root layout with providers
│   ├── page.tsx        # Home page
│   └── providers.tsx   # Web3 providers
├── components/
│   └── Navigation.tsx  # Navigation component
└── config/
    └── wagmi.ts        # Wagmi configuration
```

## Next Steps

1. Deploy smart contracts to Monad testnet
2. Update contract addresses in environment variables
3. Implement IPFS integration for content storage
4. Add content reading functionality
5. Implement reward distribution system
6. Add user authentication and profiles
7. Implement content moderation system
