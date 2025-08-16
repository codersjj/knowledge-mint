// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/KMToken.sol";
import "../src/ContentRegistry.sol";
import "../src/RewardCalculator.sol";
import "../src/AntiBot.sol";
import "../src/KnowledgeMint.sol";

/**
 * @title Deploy
 * @dev KnowledgeMint 平台部署脚本
 */
contract Deploy is Script {
    // 部署的合约地址
    KMToken public kmToken;
    ContentRegistry public contentRegistry;
    RewardCalculator public rewardCalculator;
    AntiBot public antiBot;
    KnowledgeMint public knowledgeMint;

    // 配置地址
    address public rewardPool;
    address public teamPool;
    address public ecosystemPool;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);

        vm.startBroadcast(deployerPrivateKey);

        console.log("Deploying KnowledgeMint platform contracts...");
        console.log("Deployer address:", deployer);

        // 设置池地址（这里使用部署者地址作为示例）
        rewardPool = deployer;
        teamPool = deployer;
        ecosystemPool = deployer;

        console.log("Reward Pool:", rewardPool);
        console.log("Team Pool:", teamPool);
        console.log("Ecosystem Pool:", ecosystemPool);

        // 1. 部署 KMToken
        console.log("\n1. Deploying KMToken...");
        kmToken = new KMToken(rewardPool, teamPool, ecosystemPool);
        console.log("KMToken deployed at:", address(kmToken));

        // 2. 部署 ContentRegistry
        console.log("\n2. Deploying ContentRegistry...");
        contentRegistry = new ContentRegistry();
        console.log("ContentRegistry deployed at:", address(contentRegistry));

        // 3. 部署 RewardCalculator
        console.log("\n3. Deploying RewardCalculator...");
        rewardCalculator = new RewardCalculator(
            address(contentRegistry),
            address(kmToken)
        );
        console.log("RewardCalculator deployed at:", address(rewardCalculator));

        // 4. 部署 AntiBot
        console.log("\n4. Deploying AntiBot...");
        antiBot = new AntiBot();
        console.log("AntiBot deployed at:", address(antiBot));

        // 5. 部署 KnowledgeMint 主合约
        console.log("\n5. Deploying KnowledgeMint...");
        knowledgeMint = new KnowledgeMint(
            address(kmToken),
            address(contentRegistry),
            address(rewardCalculator),
            address(antiBot)
        );
        console.log("KnowledgeMint deployed at:", address(knowledgeMint));

        // 6. 设置权限和配置
        console.log("\n6. Setting up permissions and configurations...");

        // 将 ContentRegistry 的所有权转移给 KnowledgeMint
        contentRegistry.transferOwnership(address(knowledgeMint));
        console.log("ContentRegistry ownership transferred to KnowledgeMint");

        // 将 AntiBot 的所有权转移给 KnowledgeMint
        antiBot.transferOwnership(address(knowledgeMint));
        console.log("AntiBot ownership transferred to KnowledgeMint");

        // 验证部署
        console.log("\n7. Verifying deployment...");
        _verifyDeployment();

        vm.stopBroadcast();

        console.log("\n✅ Deployment completed successfully!");
        console.log("\n📋 Contract Addresses:");
        console.log("KMToken:", address(kmToken));
        console.log("ContentRegistry:", address(contentRegistry));
        console.log("RewardCalculator:", address(rewardCalculator));
        console.log("AntiBot:", address(antiBot));
        console.log("KnowledgeMint:", address(knowledgeMint));

        console.log("\n🔧 Next steps:");
        console.log(
            "1. Update frontend environment variables with contract addresses"
        );
        console.log("2. Test basic functionality on testnet");
        console.log("3. Run contract tests: forge test");
        console.log("4. Verify contracts on block explorer");
    }

    /**
     * @dev 验证部署
     */
    function _verifyDeployment() internal view {
        // 验证 KMToken
        require(
            kmToken.rewardPool() == rewardPool,
            "KMToken reward pool mismatch"
        );
        require(kmToken.teamPool() == teamPool, "KMToken team pool mismatch");
        require(
            kmToken.ecosystemPool() == ecosystemPool,
            "KMToken ecosystem pool mismatch"
        );

        // 验证 RewardCalculator
        require(
            address(rewardCalculator.contentRegistry()) ==
                address(contentRegistry),
            "RewardCalculator content registry mismatch"
        );
        require(
            address(rewardCalculator.kmToken()) == address(kmToken),
            "RewardCalculator km token mismatch"
        );

        // 验证 KnowledgeMint
        require(
            address(knowledgeMint.kmToken()) == address(kmToken),
            "KnowledgeMint km token mismatch"
        );
        require(
            address(knowledgeMint.contentRegistry()) ==
                address(contentRegistry),
            "KnowledgeMint content registry mismatch"
        );
        require(
            address(knowledgeMint.rewardCalculator()) ==
                address(rewardCalculator),
            "KnowledgeMint reward calculator mismatch"
        );
        require(
            address(knowledgeMint.antiBot()) == address(antiBot),
            "KnowledgeMint anti bot mismatch"
        );

        console.log("✅ All contract verifications passed!");
    }

    /**
     * @dev 获取部署的合约地址
     */
    function getDeployedAddresses()
        external
        view
        returns (
            address _kmToken,
            address _contentRegistry,
            address _rewardCalculator,
            address _antiBot,
            address _knowledgeMint
        )
    {
        _kmToken = address(kmToken);
        _contentRegistry = address(contentRegistry);
        _rewardCalculator = address(rewardCalculator);
        _antiBot = address(antiBot);
        _knowledgeMint = address(knowledgeMint);
    }
}
