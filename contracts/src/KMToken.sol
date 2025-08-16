// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

/**
 * @title KMToken
 * @dev KnowledgeMint 平台代币 (ERC-20)
 * 用于奖励内容创作者和读者
 */
contract KMToken is ERC20, Ownable, Pausable {
    // 代币信息
    uint256 public constant INITIAL_SUPPLY = 100_000_000 * 10 ** 18; // 1亿代币
    uint256 public constant REWARD_POOL = 60_000_000 * 10 ** 18; // 60% 用于奖励池
    uint256 public constant TEAM_POOL = 20_000_000 * 10 ** 18; // 20% 用于团队
    uint256 public constant ECOSYSTEM_POOL = 20_000_000 * 10 ** 18; // 20% 用于生态建设

    // 地址
    address public rewardPool;
    address public teamPool;
    address public ecosystemPool;

    // 事件
    event RewardPoolSet(address indexed rewardPool);
    event TeamPoolSet(address indexed teamPool);
    event EcosystemPoolSet(address indexed ecosystemPool);
    event RewardsDistributed(address indexed to, uint256 amount);

    constructor(
        address _rewardPool,
        address _teamPool,
        address _ecosystemPool
    ) ERC20("KnowledgeMint Token", "KMT") Ownable(msg.sender) {
        require(_rewardPool != address(0), "Invalid reward pool address");
        require(_teamPool != address(0), "Invalid team pool address");
        require(_ecosystemPool != address(0), "Invalid ecosystem pool address");

        rewardPool = _rewardPool;
        teamPool = _teamPool;
        ecosystemPool = _ecosystemPool;

        // 铸造初始代币
        _mint(rewardPool, REWARD_POOL);
        _mint(teamPool, TEAM_POOL);
        _mint(ecosystemPool, ECOSYSTEM_POOL);
    }

    /**
     * @dev 设置奖励池地址
     * @param _rewardPool 新的奖励池地址
     */
    function setRewardPool(address _rewardPool) external onlyOwner {
        require(_rewardPool != address(0), "Invalid address");
        rewardPool = _rewardPool;
        emit RewardPoolSet(_rewardPool);
    }

    /**
     * @dev 设置团队池地址
     * @param _teamPool 新的团队池地址
     */
    function setTeamPool(address _teamPool) external onlyOwner {
        require(_teamPool != address(0), "Invalid address");
        teamPool = _teamPool;
        emit TeamPoolSet(_teamPool);
    }

    /**
     * @dev 设置生态池地址
     * @param _ecosystemPool 新的生态池地址
     */
    function setEcosystemPool(address _ecosystemPool) external onlyOwner {
        require(_ecosystemPool != address(0), "Invalid address");
        ecosystemPool = _ecosystemPool;
        emit EcosystemPoolSet(_ecosystemPool);
    }

    /**
     * @dev 分发奖励
     * @param to 接收者地址
     * @param amount 奖励数量
     */
    function distributeRewards(address to, uint256 amount) external {
        require(msg.sender == rewardPool, "Only reward pool can distribute");
        require(to != address(0), "Invalid recipient");
        require(amount > 0, "Amount must be greater than 0");
        require(
            balanceOf(rewardPool) >= amount,
            "Insufficient balance in reward pool"
        );

        _transfer(rewardPool, to, amount);
        emit RewardsDistributed(to, amount);
    }

    /**
     * @dev 暂停合约
     */
    function pause() external onlyOwner {
        _pause();
    }

    /**
     * @dev 恢复合约
     */
    function unpause() external onlyOwner {
        _unpause();
    }

    /**
     * @dev 重写 _beforeTokenTransfer 以支持暂停功能
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual override {
        super._beforeTokenTransfer(from, to, amount);
        require(!paused(), "Token transfer paused");
    }

    /**
     * @dev 销毁代币
     * @param amount 销毁数量
     */
    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }
}
