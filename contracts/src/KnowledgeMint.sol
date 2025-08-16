// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./KMToken.sol";
import "./ContentRegistry.sol";
import "./RewardCalculator.sol";
import "./AntiBot.sol";

/**
 * @title KnowledgeMint
 * @dev KnowledgeMint 主平台合约
 * 整合内容管理、奖励分发、反机器人保护等功能
 */
contract KnowledgeMint {
    // 合约地址
    KMToken public kmToken;
    ContentRegistry public contentRegistry;
    RewardCalculator public rewardCalculator;
    AntiBot public antiBot;

    // 平台统计
    uint256 public totalContentPublished;
    uint256 public totalRewardsDistributed;
    uint256 public totalActiveUsers;

    // 用户统计
    mapping(address => uint256) public userTotalEarnings;
    mapping(address => uint256) public userContentCount;
    mapping(address => uint256) public userReadCount;

    // 事件
    event PlatformInitialized(
        address indexed kmToken,
        address indexed contentRegistry,
        address indexed rewardCalculator,
        address antiBot
    );

    event ContentPublished(
        uint256 indexed contentId,
        address indexed creator,
        string contentHash,
        uint256 baseReward
    );

    event ContentRead(
        uint256 indexed contentId,
        address indexed reader,
        uint256 reward,
        uint256 timeSpent
    );

    event RewardsClaimed(address indexed user, uint256 amount);
    event UserRegistered(address indexed user);

    // 修饰符
    modifier onlyValidUser() {
        require(
            antiBot.validateUserAction(
                msg.sender,
                AntiBot.ActionType.READ_CONTENT
            ),
            "User validation failed"
        );
        _;
    }

    modifier onlyContentCreator() {
        require(userContentCount[msg.sender] > 0, "Not a content creator");
        _;
    }

    constructor(
        address _kmToken,
        address _contentRegistry,
        address _rewardCalculator,
        address _antiBot
    ) {
        require(_kmToken != address(0), "Invalid KMToken address");
        require(
            _contentRegistry != address(0),
            "Invalid ContentRegistry address"
        );
        require(
            _rewardCalculator != address(0),
            "Invalid RewardCalculator address"
        );
        require(_antiBot != address(0), "Invalid AntiBot address");

        kmToken = KMToken(_kmToken);
        contentRegistry = ContentRegistry(_contentRegistry);
        rewardCalculator = RewardCalculator(_rewardCalculator);
        antiBot = AntiBot(_antiBot);

        emit PlatformInitialized(
            _kmToken,
            _contentRegistry,
            _rewardCalculator,
            _antiBot
        );
    }

    /**
     * @dev 发布新内容
     * @param _contentHash IPFS 内容哈希
     * @param _title 内容标题
     * @param _description 内容描述
     * @param _category 内容分类
     * @param _tags 内容标签
     * @param _baseReward 基础奖励
     * @param _qualityBonus 质量奖励倍数
     * @param _allowComments 是否允许评论
     */
    function publishContent(
        string calldata _contentHash,
        string calldata _title,
        string calldata _description,
        string calldata _category,
        string[] calldata _tags,
        uint256 _baseReward,
        uint256 _qualityBonus,
        bool _allowComments
    ) external onlyValidUser {
        // 验证用户行为
        require(
            antiBot.validateUserAction(
                msg.sender,
                AntiBot.ActionType.PUBLISH_CONTENT
            ),
            "Action validation failed"
        );

        // 发布内容
        contentRegistry.publishContent(
            _contentHash,
            _title,
            _description,
            _category,
            _tags,
            _baseReward,
            _qualityBonus,
            _allowComments
        );

        // 更新统计
        uint256 contentId = contentRegistry.getContentCount();
        totalContentPublished++;
        userContentCount[msg.sender]++;

        // 记录用户行为
        antiBot.recordUserAction(
            msg.sender,
            AntiBot.ActionType.PUBLISH_CONTENT,
            true
        );

        emit ContentPublished(contentId, msg.sender, _contentHash, _baseReward);
    }

    /**
     * @dev 阅读内容并记录
     * @param _contentId 内容ID
     * @param _timeSpent 阅读时间（秒）
     * @param _completed 是否完成阅读
     */
    function readContent(
        uint256 _contentId,
        uint256 _timeSpent,
        bool _completed
    ) external onlyValidUser {
        // 验证用户行为
        require(
            antiBot.validateUserAction(
                msg.sender,
                AntiBot.ActionType.READ_CONTENT
            ),
            "Action validation failed"
        );

        // 记录阅读
        contentRegistry.recordRead(_contentId, _timeSpent, _completed);

        // 计算并分发奖励
        rewardCalculator.calculateAndDistributeRewards(
            _contentId,
            _timeSpent,
            _completed
        );

        // 更新统计
        userReadCount[msg.sender]++;
        totalRewardsDistributed += rewardCalculator.BASE_READ_REWARD();

        // 记录用户行为
        antiBot.recordUserAction(
            msg.sender,
            AntiBot.ActionType.READ_CONTENT,
            true
        );

        emit ContentRead(
            _contentId,
            msg.sender,
            rewardCalculator.BASE_READ_REWARD(),
            _timeSpent
        );
    }

    /**
     * @dev 对内容进行评分
     * @param _contentId 内容ID
     * @param _score 评分 (1-10)
     */
    function rateContent(
        uint256 _contentId,
        uint256 _score
    ) external onlyValidUser {
        // 验证用户行为
        require(
            antiBot.validateUserAction(
                msg.sender,
                AntiBot.ActionType.RATE_CONTENT
            ),
            "Action validation failed"
        );

        // 提交评分
        rewardCalculator.submitQualityScore(_contentId, _score);

        // 记录用户行为
        antiBot.recordUserAction(
            msg.sender,
            AntiBot.ActionType.RATE_CONTENT,
            true
        );
    }

    /**
     * @dev 添加评论
     * @param _contentId 内容ID
     * @param _text 评论内容
     */
    function addComment(
        uint256 _contentId,
        string calldata _text
    ) external onlyValidUser {
        // 验证用户行为
        require(
            antiBot.validateUserAction(
                msg.sender,
                AntiBot.ActionType.COMMENT_CONTENT
            ),
            "Action validation failed"
        );

        // 添加评论
        contentRegistry.addComment(_contentId, _text);

        // 记录用户行为
        antiBot.recordUserAction(
            msg.sender,
            AntiBot.ActionType.COMMENT_CONTENT,
            true
        );
    }

    /**
     * @dev 更新内容
     * @param _contentId 内容ID
     * @param _contentHash 新的IPFS哈希
     * @param _title 新标题
     * @param _description 新描述
     */
    function updateContent(
        uint256 _contentId,
        string calldata _contentHash,
        string calldata _title,
        string calldata _description
    ) external onlyContentCreator {
        contentRegistry.updateContent(
            _contentId,
            _contentHash,
            _title,
            _description
        );
    }

    /**
     * @dev 停用内容
     * @param _contentId 内容ID
     */
    function deactivateContent(uint256 _contentId) external {
        contentRegistry.deactivateContent(_contentId);
    }

    /**
     * @dev 获取用户统计信息
     * @param _user 用户地址
     * @return totalEarnings 总收益
     * @return contentCount 内容数量
     * @return readCount 阅读数量
     */
    function getUserStats(
        address _user
    )
        external
        view
        returns (uint256 totalEarnings, uint256 contentCount, uint256 readCount)
    {
        totalEarnings = userTotalEarnings[_user];
        contentCount = userContentCount[_user];
        readCount = userReadCount[_user];
    }

    /**
     * @dev 获取平台统计信息
     * @return _totalContentPublished 总发布内容数
     * @return _totalRewardsDistributed 总分发奖励数
     * @return _totalActiveUsers 总活跃用户数
     */
    function getPlatformStats()
        external
        view
        returns (
            uint256 _totalContentPublished,
            uint256 _totalRewardsDistributed,
            uint256 _totalActiveUsers
        )
    {
        _totalContentPublished = totalContentPublished;
        _totalRewardsDistributed = totalRewardsDistributed;
        _totalActiveUsers = totalActiveUsers;
    }

    /**
     * @dev 获取内容信息
     * @param _contentId 内容ID
     * @return 内容结构
     */
    function getContent(
        uint256 _contentId
    ) external view returns (ContentRegistry.Content memory) {
        return contentRegistry.getContent(_contentId);
    }

    /**
     * @dev 获取创作者的內容列表
     * @param _creator 创作者地址
     * @return 内容ID数组
     */
    function getCreatorContents(
        address _creator
    ) external view returns (uint256[] memory) {
        return contentRegistry.getCreatorContents(_creator);
    }

    /**
     * @dev 获取读者的阅读历史
     * @param _reader 读者地址
     * @return 内容ID数组
     */
    function getReaderHistory(
        address _reader
    ) external view returns (uint256[] memory) {
        return contentRegistry.getReaderHistory(_reader);
    }

    /**
     * @dev 获取内容的阅读记录
     * @param _contentId 内容ID
     * @return 阅读记录数组
     */
    function getReadRecords(
        uint256 _contentId
    ) external view returns (ContentRegistry.ReadRecord[] memory) {
        return contentRegistry.getReadRecords(_contentId);
    }

    /**
     * @dev 获取内容的评论
     * @param _contentId 内容ID
     * @return 评论数组
     */
    function getComments(
        uint256 _contentId
    ) external view returns (ContentRegistry.Comment[] memory) {
        return contentRegistry.getComments(_contentId);
    }

    /**
     * @dev 获取内容的平均质量评分
     * @param _contentId 内容ID
     * @return 平均质量评分
     */
    function getContentQualityScore(
        uint256 _contentId
    ) external view returns (uint256) {
        return rewardCalculator.getContentQualityScore(_contentId);
    }

    /**
     * @dev 获取用户的每日奖励
     * @param _user 用户地址
     * @return 每日奖励数量
     */
    function getUserDailyRewards(
        address _user
    ) external view returns (uint256) {
        return rewardCalculator.getUserDailyRewards(_user);
    }

    /**
     * @dev 检查用户是否达到每日奖励限制
     * @param _user 用户地址
     * @return 是否达到限制
     */
    function isUserDailyRewardLimitReached(
        address _user
    ) external view returns (bool) {
        return rewardCalculator.isUserDailyRewardLimitReached(_user);
    }

    /**
     * @dev 获取用户行为信息
     * @param _user 用户地址
     * @return 用户行为结构
     */
    function getUserBehavior(
        address _user
    ) external view returns (AntiBot.UserBehavior memory) {
        return antiBot.getUserBehavior(_user);
    }

    /**
     * @dev 检查用户是否被黑名单
     * @param _user 用户地址
     * @return 是否被黑名单
     */
    function isUserBlacklisted(address _user) external view returns (bool) {
        return antiBot.isUserBlacklisted(_user);
    }

    /**
     * @dev 获取用户可疑活动次数
     * @param _user 用户地址
     * @return 可疑活动次数
     */
    function getSuspiciousActivityCount(
        address _user
    ) external view returns (uint256) {
        return antiBot.getSuspiciousActivityCount(_user);
    }

    /**
     * @dev 获取代币余额
     * @param _user 用户地址
     * @return 代币余额
     */
    function getTokenBalance(address _user) external view returns (uint256) {
        return kmToken.balanceOf(_user);
    }

    /**
     * @dev 获取内容总数
     * @return 内容总数
     */
    function getContentCount() external view returns (uint256) {
        return contentRegistry.getContentCount();
    }

    /**
     * @dev 获取评论总数
     * @return 评论总数
     */
    function getCommentCount() external view returns (uint256) {
        return contentRegistry.getCommentCount();
    }
}
