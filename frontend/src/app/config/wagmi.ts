import { http, createConfig } from "wagmi";
import { monadTestnet } from "wagmi/chains";
import { injected, metaMask, walletConnect } from "wagmi/connectors";
import { getDefaultConfig } from '@rainbow-me/rainbowkit';

export const config = getDefaultConfig({
  appName: 'KnowledgeMint',
  projectId: process.env.NEXT_PUBLIC_WALLETCONNECT_PROJECT_ID || 'default',
  chains: [monadTestnet],
  ssr: true, // 启用 SSR 支持
}); 
