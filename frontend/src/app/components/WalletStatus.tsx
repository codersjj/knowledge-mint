"use client";

import { useAccount, useConnect, useDisconnect } from "wagmi";
import { ConnectButton } from "@rainbow-me/rainbowkit";

export default function WalletStatus() {
  const { address, isConnected } = useAccount();
  const { connect, connectors, error } = useConnect();
  const { disconnect } = useDisconnect();

  return (
    <div className="flex items-center space-x-4">
      {/* 连接状态显示 */}
      <div className="text-sm text-gray-600">
        {isConnected ? (
          <div className="flex items-center space-x-2">
            <div className="w-2 h-2 bg-green-500 rounded-full"></div>
            <span>
              已连接: {address?.slice(0, 6)}...{address?.slice(-4)}
            </span>
          </div>
        ) : (
          <div className="flex items-center space-x-2">
            <div className="w-2 h-2 bg-red-500 rounded-full"></div>
            <span>未连接</span>
          </div>
        )}
      </div>

      {/* RainbowKit 连接按钮 */}
      <ConnectButton />

      {/* 调试信息 */}
      {process.env.NODE_ENV === "development" && (
        <div className="text-xs text-gray-500">
          <div>可用连接器: {connectors.length}</div>
          {error && <div>错误: {error.message}</div>}
        </div>
      )}
    </div>
  );
}
