// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

/**
 * @title AntiBot
 * @dev 反机器人保护和真实参与验证合约
 */
contract AntiBot is Ownable, ReentrancyGuard {
    // 用户行为记录
    struct UserBehavior {
        uint256 lastActionTime;
        uint256 dailyActionCount;
        uint256 lastActionDate;
        uint256 reputationScore;
        bool isVerified;
        uint256[] recentActions;
    }

    // 行为类型
    enum ActionType {
        READ_CONTENT,
        PUBLISH_CONTENT,
        RATE_CONTENT,
        COMMENT_CONTENT
    }

    // 配置参数
    uint256 public constant MAX_DAILY_ACTIONS = 100; // 每日最大操作次数
    uint256 public constant MIN_ACTION_INTERVAL = 30; // 最小操作间隔（秒）
    uint256 public constant REPUTATION_THRESHOLD = 50; // 信誉分数阈值
    uint256 public constant MAX_REPUTATION_SCORE = 100; // 最大信誉分数

    // 状态变量
    mapping(address => UserBehavior) public userBehaviors;
    mapping(address => bool) public blacklistedAddresses;
    mapping(address => uint256) public suspiciousActivityCount;

    // 事件
    event UserVerified(address indexed user, uint256 reputationScore);
    event UserBlacklisted(address indexed user, string reason);
    event SuspiciousActivityDetected(
        address indexed user,
        ActionType actionType,
        string reason
    );
    event ReputationUpdated(
        address indexed user,
        uint256 oldScore,
        uint256 newScore
    );

    constructor() Ownable(msg.sender) {}

    /**
     * @dev 验证用户行为
     * @param _user 用户地址
     * @param _actionType 行为类型
     * @return 是否通过验证
     */
    function validateUserAction(
        address _user,
        ActionType _actionType
    ) external returns (bool) {
        require(_user != address(0), "Invalid user address");
        require(!blacklistedAddresses[_user], "User is blacklisted");

        UserBehavior storage behavior = userBehaviors[_user];
        uint256 currentTime = block.timestamp;
        uint256 currentDate = currentTime / 1 days;

        // 检查操作频率
        if (!_checkActionFrequency(_user, currentTime, currentDate)) {
            _recordSuspiciousActivity(
                _user,
                _actionType,
                "High frequency actions"
            );
            return false;
        }

        // 检查操作间隔
        if (!_checkActionInterval(_user, currentTime)) {
            _recordSuspiciousActivity(
                _user,
                _actionType,
                "Actions too frequent"
            );
            return false;
        }

        // 更新用户行为记录
        _updateUserBehavior(_user, currentTime, currentDate);

        // 检查信誉分数
        if (behavior.reputationScore < REPUTATION_THRESHOLD) {
            _recordSuspiciousActivity(
                _user,
                _actionType,
                "Low reputation score"
            );
            return false;
        }

        return true;
    }

    /**
     * @dev 记录用户行为
     * @param _user 用户地址
     * @param _actionType 行为类型
     * @param _success 行为是否成功
     */
    function recordUserAction(
        address _user,
        ActionType _actionType,
        bool _success
    ) external {
        UserBehavior storage behavior = userBehaviors[_user];

        if (_success) {
            // 成功的行为增加信誉分数
            _increaseReputation(_user, _getActionReputationValue(_actionType));
        } else {
            // 失败的行为减少信誉分数
            _decreaseReputation(_user, _getActionReputationValue(_actionType));
        }
    }

    /**
     * @dev 验证用户身份
     * @param _user 用户地址
     * @param _proof 身份验证证明
     */
    function verifyUser(
        address _user,
        bytes calldata _proof
    ) external onlyOwner {
        require(_user != address(0), "Invalid user address");
        require(!userBehaviors[_user].isVerified, "User already verified");

        // 这里可以添加更复杂的身份验证逻辑
        // 例如：验证签名、检查链上数据等

        UserBehavior storage behavior = userBehaviors[_user];
        behavior.isVerified = true;
        behavior.reputationScore = REPUTATION_THRESHOLD;

        emit UserVerified(_user, behavior.reputationScore);
    }

    /**
     * @dev 将用户加入黑名单
     * @param _user 用户地址
     * @param _reason 黑名单原因
     */
    function blacklistUser(
        address _user,
        string calldata _reason
    ) external onlyOwner {
        require(_user != address(0), "Invalid user address");
        require(!blacklistedAddresses[_user], "User already blacklisted");

        blacklistedAddresses[_user] = true;
        emit UserBlacklisted(_user, _reason);
    }

    /**
     * @dev 将用户从黑名单移除
     * @param _user 用户地址
     */
    function removeFromBlacklist(address _user) external onlyOwner {
        require(blacklistedAddresses[_user], "User not blacklisted");

        blacklistedAddresses[_user] = false;
    }

    /**
     * @dev 检查操作频率
     * @param _user 用户地址
     * @param _currentTime 当前时间
     * @param _currentDate 当前日期
     * @return 是否通过频率检查
     */
    function _checkActionFrequency(
        address _user,
        uint256 _currentTime,
        uint256 _currentDate
    ) internal view returns (bool) {
        UserBehavior storage behavior = userBehaviors[_user];

        if (_currentDate > behavior.lastActionDate) {
            // 新的一天，重置计数
            return true;
        }

        return behavior.dailyActionCount < MAX_DAILY_ACTIONS;
    }

    /**
     * @dev 检查操作间隔
     * @param _user 用户地址
     * @param _currentTime 当前时间
     * @return 是否通过间隔检查
     */
    function _checkActionInterval(
        address _user,
        uint256 _currentTime
    ) internal view returns (bool) {
        UserBehavior storage behavior = userBehaviors[_user];

        if (behavior.lastActionTime == 0) {
            return true; // 第一次操作
        }

        return (_currentTime - behavior.lastActionTime) >= MIN_ACTION_INTERVAL;
    }

    /**
     * @dev 更新用户行为记录
     * @param _user 用户地址
     * @param _currentTime 当前时间
     * @param _currentDate 当前日期
     */
    function _updateUserBehavior(
        address _user,
        uint256 _currentTime,
        uint256 _currentDate
    ) internal {
        UserBehavior storage behavior = userBehaviors[_user];

        if (_currentDate > behavior.lastActionDate) {
            // 新的一天，重置计数
            behavior.dailyActionCount = 1;
            behavior.lastActionDate = _currentDate;
        } else {
            // 同一天，增加计数
            behavior.dailyActionCount++;
        }

        behavior.lastActionTime = _currentTime;

        // 更新最近操作记录
        if (behavior.recentActions.length >= 10) {
            // 保持最近10个操作
            for (uint i = 0; i < 9; i++) {
                behavior.recentActions[i] = behavior.recentActions[i + 1];
            }
            behavior.recentActions[9] = _currentTime;
        } else {
            behavior.recentActions.push(_currentTime);
        }
    }

    /**
     * @dev 增加信誉分数
     * @param _user 用户地址
     * @param _amount 增加的数量
     */
    function _increaseReputation(address _user, uint256 _amount) internal {
        UserBehavior storage behavior = userBehaviors[_user];
        uint256 oldScore = behavior.reputationScore;

        behavior.reputationScore = behavior.reputationScore + _amount;
        if (behavior.reputationScore > MAX_REPUTATION_SCORE) {
            behavior.reputationScore = MAX_REPUTATION_SCORE;
        }

        emit ReputationUpdated(_user, oldScore, behavior.reputationScore);
    }

    /**
     * @dev 减少信誉分数
     * @param _user 用户地址
     * @param _amount 减少的数量
     */
    function _decreaseReputation(address _user, uint256 _amount) internal {
        UserBehavior storage behavior = userBehaviors[_user];
        uint256 oldScore = behavior.reputationScore;

        if (behavior.reputationScore > _amount) {
            behavior.reputationScore = behavior.reputationScore - _amount;
        } else {
            behavior.reputationScore = 0;
        }

        emit ReputationUpdated(_user, oldScore, behavior.reputationScore);
    }

    /**
     * @dev 获取行为的信誉价值
     * @param _actionType 行为类型
     * @return 信誉价值
     */
    function _getActionReputationValue(
        ActionType _actionType
    ) internal pure returns (uint256) {
        if (_actionType == ActionType.READ_CONTENT) return 1;
        if (_actionType == ActionType.PUBLISH_CONTENT) return 5;
        if (_actionType == ActionType.RATE_CONTENT) return 2;
        if (_actionType == ActionType.COMMENT_CONTENT) return 3;
        return 1;
    }

    /**
     * @dev 记录可疑活动
     * @param _user 用户地址
     * @param _actionType 行为类型
     * @param _reason 可疑原因
     */
    function _recordSuspiciousActivity(
        address _user,
        ActionType _actionType,
        string memory _reason
    ) internal {
        suspiciousActivityCount[_user]++;

        emit SuspiciousActivityDetected(_user, _actionType, _reason);

        // 如果可疑活动次数过多，自动加入黑名单
        if (suspiciousActivityCount[_user] >= 5) {
            blacklistedAddresses[_user] = true;
            emit UserBlacklisted(_user, "Multiple suspicious activities");
        }
    }

    /**
     * @dev 获取用户行为信息
     * @param _user 用户地址
     * @return 用户行为结构
     */
    function getUserBehavior(
        address _user
    ) external view returns (UserBehavior memory) {
        return userBehaviors[_user];
    }

    /**
     * @dev 检查用户是否被黑名单
     * @param _user 用户地址
     * @return 是否被黑名单
     */
    function isUserBlacklisted(address _user) external view returns (bool) {
        return blacklistedAddresses[_user];
    }

    /**
     * @dev 获取用户可疑活动次数
     * @param _user 用户地址
     * @return 可疑活动次数
     */
    function getSuspiciousActivityCount(
        address _user
    ) external view returns (uint256) {
        return suspiciousActivityCount[_user];
    }

    /**
     * @dev 更新配置参数
     * @param _maxDailyActions 每日最大操作次数
     * @param _minActionInterval 最小操作间隔
     * @param _reputationThreshold 信誉分数阈值
     */
    function updateConfig(
        uint256 _maxDailyActions,
        uint256 _minActionInterval,
        uint256 _reputationThreshold
    ) external onlyOwner {
        require(_maxDailyActions > 0, "Invalid max daily actions");
        require(_minActionInterval > 0, "Invalid min action interval");
        require(
            _reputationThreshold <= MAX_REPUTATION_SCORE,
            "Invalid reputation threshold"
        );

        // 这里可以添加配置更新逻辑
    }
}
