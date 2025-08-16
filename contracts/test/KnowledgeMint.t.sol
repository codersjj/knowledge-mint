// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/KMToken.sol";
import "../src/ContentRegistry.sol";
import "../src/RewardCalculator.sol";
import "../src/AntiBot.sol";
import "../src/KnowledgeMint.sol";

contract KnowledgeMintTest is Test {
    KnowledgeMint public knowledgeMint;
    KMToken public kmToken;
    ContentRegistry public contentRegistry;
    RewardCalculator public rewardCalculator;
    AntiBot public antiBot;

    address public deployer;
    address public user1;
    address public user2;

    function setUp() public {
        deployer = address(this);
        user1 = makeAddr("user1");
        user2 = makeAddr("user2");

        // 部署合约
        kmToken = new KMToken(deployer, deployer, deployer);
        contentRegistry = new ContentRegistry();
        rewardCalculator = new RewardCalculator(
            address(contentRegistry),
            address(kmToken)
        );
        antiBot = new AntiBot();
        knowledgeMint = new KnowledgeMint(
            address(kmToken),
            address(contentRegistry),
            address(rewardCalculator),
            address(antiBot)
        );

        // 转移所有权
        contentRegistry.transferOwnership(address(knowledgeMint));
        antiBot.transferOwnership(address(knowledgeMint));

        // 给用户一些代币用于测试
        vm.startPrank(deployer);
        kmToken.transfer(user1, 1000 * 10 ** 18);
        kmToken.transfer(user2, 1000 * 10 ** 18);
        vm.stopPrank();
    }

    function testDeployment() public {
        assertEq(address(knowledgeMint.kmToken()), address(kmToken));
        assertEq(
            address(knowledgeMint.contentRegistry()),
            address(contentRegistry)
        );
        assertEq(
            address(knowledgeMint.rewardCalculator()),
            address(rewardCalculator)
        );
        assertEq(address(knowledgeMint.antiBot()), address(antiBot));
    }

    function testPublishContent() public {
        vm.startPrank(user1);

        // 验证用户行为
        antiBot.verifyUser(user1, "");

        // 发布内容
        string[] memory tags = new string[](2);
        tags[0] = "blockchain";
        tags[1] = "solidity";

        knowledgeMint.publishContent(
            "QmHash123",
            "Solidity 入门教程",
            "这是一个 Solidity 入门教程",
            "教程",
            tags,
            10 * 10 ** 18, // 10 KMT 基础奖励
            150, // 150% 质量奖励
            true // 允许评论
        );

        // 验证内容发布
        assertEq(knowledgeMint.getContentCount(), 1);
        assertEq(knowledgeMint.userContentCount(user1), 1);

        vm.stopPrank();
    }

    function testReadContent() public {
        // 先发布内容
        vm.startPrank(user1);
        antiBot.verifyUser(user1, "");

        string[] memory tags = new string[](1);
        tags[0] = "test";

        knowledgeMint.publishContent(
            "QmHash456",
            "测试内容",
            "这是一个测试内容",
            "测试",
            tags,
            5 * 10 ** 18,
            100,
            true
        );
        vm.stopPrank();

        // 用户2阅读内容
        vm.startPrank(user2);
        antiBot.verifyUser(user2, "");

        uint256 initialBalance = kmToken.balanceOf(user2);

        knowledgeMint.readContent(1, 300, true); // 阅读5分钟，完成

        uint256 finalBalance = kmToken.balanceOf(user2);
        assertGt(
            finalBalance,
            initialBalance,
            "Should receive rewards for reading"
        );

        vm.stopPrank();
    }

    function testRateContent() public {
        // 先发布内容
        vm.startPrank(user1);
        antiBot.verifyUser(user1, "");

        string[] memory tags = new string[](1);
        tags[0] = "test";

        knowledgeMint.publishContent(
            "QmHash789",
            "评分测试内容",
            "这是一个用于测试评分的内容",
            "测试",
            tags,
            5 * 10 ** 18,
            100,
            true
        );
        vm.stopPrank();

        // 用户2评分
        vm.startPrank(user2);
        antiBot.verifyUser(user2, "");

        knowledgeMint.rateContent(1, 8); // 评分8分

        uint256 qualityScore = knowledgeMint.getContentQualityScore(1);
        assertEq(qualityScore, 8, "Quality score should be 8");

        vm.stopPrank();
    }

    function testAddComment() public {
        // 先发布内容
        vm.startPrank(user1);
        antiBot.verifyUser(user1, "");

        string[] memory tags = new string[](1);
        tags[0] = "test";

        knowledgeMint.publishContent(
            "QmHash101",
            "评论测试内容",
            "这是一个用于测试评论的内容",
            "测试",
            tags,
            5 * 10 ** 18,
            100,
            true
        );
        vm.stopPrank();

        // 用户2添加评论
        vm.startPrank(user2);
        antiBot.verifyUser(user2, "");

        knowledgeMint.addComment(1, "这是一个很好的内容！");

        ContentRegistry.Comment[] memory comments = knowledgeMint.getComments(
            1
        );
        assertEq(comments.length, 1, "Should have 1 comment");
        assertEq(
            comments[0].text,
            "这是一个很好的内容！",
            "Comment text should match"
        );

        vm.stopPrank();
    }

    function testUserStats() public {
        vm.startPrank(user1);
        antiBot.verifyUser(user1, "");

        // 发布内容
        string[] memory tags = new string[](1);
        tags[0] = "test";

        knowledgeMint.publishContent(
            "QmHash202",
            "统计测试内容",
            "这是一个用于测试统计的内容",
            "测试",
            tags,
            5 * 10 ** 18,
            100,
            true
        );
        vm.stopPrank();

        // 用户2阅读内容
        vm.startPrank(user2);
        antiBot.verifyUser(user2, "");

        knowledgeMint.readContent(1, 180, true); // 阅读3分钟，完成
        vm.stopPrank();

        // 检查统计
        (
            uint256 totalEarnings,
            uint256 contentCount,
            uint256 readCount
        ) = knowledgeMint.getUserStats(user1);
        assertEq(contentCount, 1, "User1 should have 1 content");
        assertEq(readCount, 0, "User1 should have 0 reads");

        (, , readCount) = knowledgeMint.getUserStats(user2);
        assertEq(readCount, 1, "User2 should have 1 read");
    }

    function testPlatformStats() public {
        vm.startPrank(user1);
        antiBot.verifyUser(user1, "");

        // 发布内容
        string[] memory tags = new string[](1);
        tags[0] = "test";

        knowledgeMint.publishContent(
            "QmHash303",
            "平台统计测试",
            "这是一个用于测试平台统计的内容",
            "测试",
            tags,
            5 * 10 ** 18,
            100,
            true
        );
        vm.stopPrank();

        // 检查平台统计
        (
            uint256 totalContent,
            uint256 totalRewards,
            uint256 totalUsers
        ) = knowledgeMint.getPlatformStats();
        assertEq(totalContent, 1, "Platform should have 1 content");
        assertEq(totalRewards, 0, "Platform should have 0 rewards initially");
    }

    function testAntiBotProtection() public {
        vm.startPrank(user1);

        // 尝试发布内容（未验证用户）
        string[] memory tags = new string[](1);
        tags[0] = "test";

        vm.expectRevert("User validation failed");
        knowledgeMint.publishContent(
            "QmHash404",
            "反机器人测试",
            "这是一个用于测试反机器人的内容",
            "测试",
            tags,
            5 * 10 ** 18,
            100,
            true
        );

        vm.stopPrank();
    }

    function testTokenBalance() public {
        uint256 balance = knowledgeMint.getTokenBalance(user1);
        assertEq(balance, 1000 * 10 ** 18, "User1 should have 1000 KMT");

        balance = knowledgeMint.getTokenBalance(user2);
        assertEq(balance, 1000 * 10 ** 18, "User2 should have 1000 KMT");
    }
}
