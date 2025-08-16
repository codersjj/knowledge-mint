// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./ContentRegistry.sol";
import "./KMToken.sol";

/**
 * @title RewardCalculator
 * @dev 动态奖励分发逻辑合约
 */
contract RewardCalculator {
    ContentRegistry public contentRegistry;
    KMToken public kmToken;

    // 奖励配置
    uint256 public constant BASE_READ_REWARD = 5 * 10 ** 18; // 基础阅读奖励 5 KMT
    uint256 public constant COMPLETION_BONUS = 10 * 10 ** 18; // 完成阅读奖励 10 KMT
    uint256 public constant QUALITY_BONUS_MULTIPLIER = 150; // 质量奖励倍数 150%
    uint256 public constant TIME_BONUS_THRESHOLD = 300; // 时间奖励阈值 5分钟
    uint256 public constant MAX_DAILY_REWARDS = 100 * 10 ** 18; // 每日最大奖励 100 KMT

    // 用户每日奖励记录
    mapping(address => uint256) public dailyRewards;
    mapping(address => uint256) public lastRewardDate;

    // 内容质量评分
    mapping(uint256 => uint256) public contentQualityScores;
    mapping(uint256 => uint256) public qualityScoreCount;

    // 事件
    event RewardsCalculated(
        address indexed reader,
        uint256 indexed contentId,
        uint256 baseReward,
        uint256 completionBonus,
        uint256 qualityBonus,
        uint256 timeBonus,
        uint256 totalReward
    );

    event QualityScoreSubmitted(
        uint256 indexed contentId,
        address indexed rater,
        uint256 score,
        uint256 averageScore
    );

    event DailyRewardLimitReached(address indexed reader, uint256 dailyTotal);

    constructor(address _contentRegistry, address _kmToken) {
        contentRegistry = ContentRegistry(_contentRegistry);
        kmToken = KMToken(_kmToken);
    }

    /**
     * @dev 计算并分发阅读奖励
     * @param _contentId 内容ID
     * @param _timeSpent 阅读时间（秒）
     * @param _completed 是否完成阅读
     */
    function calculateAndDistributeRewards(
        uint256 _contentId,
        uint256 _timeSpent,
        bool _completed
    ) external {
        // 获取内容信息
        ContentRegistry.Content memory content = contentRegistry.getContent(
            _contentId
        );
        require(content.isActive, "Content is not active");
        require(
            msg.sender != content.creator,
            "Creator cannot earn rewards from own content"
        );

        // 检查每日奖励限制
        _checkDailyRewardLimit(msg.sender);

        // 计算各种奖励
        uint256 baseReward = _calculateBaseReward(content.baseReward);
        uint256 completionBonus = _completed ? COMPLETION_BONUS : 0;
        uint256 qualityBonus = _calculateQualityBonus(
            _contentId,
            content.qualityBonus
        );
        uint256 timeBonus = _calculateTimeBonus(_timeSpent);

        uint256 totalReward = baseReward +
            completionBonus +
            qualityBonus +
            timeBonus;

        // 更新每日奖励记录
        _updateDailyRewards(msg.sender, totalReward);

        // 分发奖励
        kmToken.distributeRewards(msg.sender, totalReward);

        // 更新内容统计
        _updateContentStats(_contentId, totalReward);

        emit RewardsCalculated(
            msg.sender,
            _contentId,
            baseReward,
            completionBonus,
            qualityBonus,
            timeBonus,
            totalReward
        );
    }

    /**
     * @dev 提交内容质量评分
     * @param _contentId 内容ID
     * @param _score 评分 (1-10)
     */
    function submitQualityScore(uint256 _contentId, uint256 _score) external {
        require(_score >= 1 && _score <= 10, "Score must be between 1 and 10");

        ContentRegistry.Content memory content = contentRegistry.getContent(
            _contentId
        );
        require(content.isActive, "Content is not active");
        require(
            msg.sender != content.creator,
            "Creator cannot rate own content"
        );

        // 更新质量评分
        uint256 currentTotal = contentQualityScores[_contentId] *
            qualityScoreCount[_contentId];
        qualityScoreCount[_contentId]++;
        contentQualityScores[_contentId] =
            (currentTotal + _score) /
            qualityScoreCount[_contentId];

        emit QualityScoreSubmitted(
            _contentId,
            msg.sender,
            _score,
            contentQualityScores[_contentId]
        );
    }

    /**
     * @dev 计算基础奖励
     * @param _contentBaseReward 内容基础奖励
     * @return 计算后的基础奖励
     */
    function _calculateBaseReward(
        uint256 _contentBaseReward
    ) internal pure returns (uint256) {
        return _contentBaseReward;
    }

    /**
     * @dev 计算质量奖励
     * @param _contentId 内容ID
     * @param _contentQualityBonus 内容质量奖励倍数
     * @return 质量奖励
     */
    function _calculateQualityBonus(
        uint256 _contentId,
        uint256 _contentQualityBonus
    ) internal view returns (uint256) {
        uint256 qualityScore = contentQualityScores[_contentId];
        if (qualityScore == 0) return 0;

        // 质量评分越高，奖励越多
        uint256 qualityMultiplier = (qualityScore * _contentQualityBonus) / 100;
        return (BASE_READ_REWARD * qualityMultiplier) / 100;
    }

    /**
     * @dev 计算时间奖励
     * @param _timeSpent 阅读时间
     * @return 时间奖励
     */
    function _calculateTimeBonus(
        uint256 _timeSpent
    ) internal pure returns (uint256) {
        if (_timeSpent < TIME_BONUS_THRESHOLD) return 0;

        // 超过阈值后，每增加1分钟增加1 KMT奖励
        uint256 extraMinutes = (_timeSpent - TIME_BONUS_THRESHOLD) / 60;
        return extraMinutes * 1 * 10 ** 18; // 每分钟1 KMT
    }

    /**
     * @dev 检查每日奖励限制
     * @param _reader 读者地址
     */
    function _checkDailyRewardLimit(address _reader) internal view {
        uint256 today = block.timestamp / 1 days;
        uint256 lastRewardDay = lastRewardDate[_reader] / 1 days;

        if (today == lastRewardDay) {
            require(
                dailyRewards[_reader] < MAX_DAILY_REWARDS,
                "Daily reward limit reached"
            );
        }
    }

    /**
     * @dev 更新每日奖励记录
     * @param _reader 读者地址
     * @param _reward 奖励数量
     */
    function _updateDailyRewards(address _reader, uint256 _reward) internal {
        uint256 today = block.timestamp / 1 days;
        uint256 lastRewardDay = lastRewardDate[_reader] / 1 days;

        if (today > lastRewardDay) {
            // 新的一天，重置奖励计数
            dailyRewards[_reader] = _reward;
            lastRewardDate[_reader] = block.timestamp;
        } else {
            // 同一天，累加奖励
            dailyRewards[_reader] += _reward;
        }

        if (dailyRewards[_reader] >= MAX_DAILY_REWARDS) {
            emit DailyRewardLimitReached(_reader, dailyRewards[_reader]);
        }
    }

    /**
     * @dev 更新内容统计
     * @param _contentId 内容ID
     * @param _reward 奖励数量
     */
    function _updateContentStats(uint256 _contentId, uint256 _reward) internal {
        // 这里可以添加更多统计逻辑
        // 例如：更新内容的平均奖励、总奖励等
    }

    /**
     * @dev 获取内容的平均质量评分
     * @param _contentId 内容ID
     * @return 平均质量评分
     */
    function getContentQualityScore(
        uint256 _contentId
    ) external view returns (uint256) {
        return contentQualityScores[_contentId];
    }

    /**
     * @dev 获取内容的评分数量
     * @param _contentId 内容ID
     * @return 评分数量
     */
    function getContentQualityScoreCount(
        uint256 _contentId
    ) external view returns (uint256) {
        return qualityScoreCount[_contentId];
    }

    /**
     * @dev 获取用户的每日奖励
     * @param _user 用户地址
     * @return 每日奖励数量
     */
    function getUserDailyRewards(
        address _user
    ) external view returns (uint256) {
        uint256 today = block.timestamp / 1 days;
        uint256 lastRewardDay = lastRewardDate[_user] / 1 days;

        if (today > lastRewardDay) {
            return 0; // 新的一天，奖励重置
        }
        return dailyRewards[_user];
    }

    /**
     * @dev 获取用户的最后奖励日期
     * @param _user 用户地址
     * @return 最后奖励日期
     */
    function getUserLastRewardDate(
        address _user
    ) external view returns (uint256) {
        return lastRewardDate[_user];
    }

    /**
     * @dev 检查用户是否达到每日奖励限制
     * @param _user 用户地址
     * @return 是否达到限制
     */
    function isUserDailyRewardLimitReached(
        address _user
    ) external view returns (bool) {
        uint256 today = block.timestamp / 1 days;
        uint256 lastRewardDay = lastRewardDate[_user] / 1 days;

        if (today > lastRewardDay) {
            return false; // 新的一天，未达到限制
        }
        return dailyRewards[_user] >= MAX_DAILY_REWARDS;
    }
}
