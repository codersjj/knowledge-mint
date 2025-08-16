// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

/**
 * @title ContentRegistry
 * @dev 内容管理和元数据存储合约
 */
contract ContentRegistry is Ownable, ReentrancyGuard {
    using Counters for Counters.Counter;

    // 内容结构
    struct Content {
        uint256 id;
        address creator;
        string contentHash; // IPFS hash
        string title;
        string description;
        string category;
        string[] tags;
        uint256 baseReward;
        uint256 qualityBonus;
        uint256 totalViews;
        uint256 totalEarnings;
        uint256 averageRating;
        uint256 publishedAt;
        bool isActive;
        bool allowComments;
        bool isFeatured;
    }

    // 阅读记录结构
    struct ReadRecord {
        address reader;
        uint256 contentId;
        uint256 readAt;
        uint256 timeSpent; // 阅读时间（秒）
        bool completed; // 是否完成阅读
    }

    // 评论结构
    struct Comment {
        uint256 id;
        address author;
        uint256 contentId;
        string text;
        uint256 timestamp;
        bool isActive;
    }

    // 状态变量
    Counters.Counter private _contentIds;
    Counters.Counter private _commentIds;

    mapping(uint256 => Content) public contents;
    mapping(uint256 => ReadRecord[]) public readRecords;
    mapping(uint256 => Comment[]) public comments;
    mapping(address => uint256[]) public creatorContents;
    mapping(address => uint256[]) public readerHistory;

    // 配置
    uint256 public minBaseReward = 1 * 10 ** 18; // 最小基础奖励 1 KMT
    uint256 public maxBaseReward = 1000 * 10 ** 18; // 最大基础奖励 1000 KMT
    uint256 public maxQualityBonus = 200; // 最大质量奖励倍数 (200%)

    // 事件
    event ContentPublished(
        uint256 indexed contentId,
        address indexed creator,
        string contentHash,
        string title,
        uint256 baseReward
    );

    event ContentUpdated(uint256 indexed contentId, string contentHash);
    event ContentDeactivated(uint256 indexed contentId);
    event ReadRecorded(
        uint256 indexed contentId,
        address indexed reader,
        uint256 timeSpent
    );
    event CommentAdded(
        uint256 indexed contentId,
        address indexed author,
        string text
    );
    event CommentRemoved(uint256 indexed contentId, uint256 commentId);

    constructor() Ownable(msg.sender) {}

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
    ) external nonReentrant {
        require(bytes(_contentHash).length > 0, "Content hash cannot be empty");
        require(bytes(_title).length > 0, "Title cannot be empty");
        require(
            _baseReward >= minBaseReward && _baseReward <= maxBaseReward,
            "Invalid base reward"
        );
        require(_qualityBonus <= maxQualityBonus, "Quality bonus too high");

        _contentIds.increment();
        uint256 contentId = _contentIds.current();

        Content storage newContent = contents[contentId];
        newContent.id = contentId;
        newContent.creator = msg.sender;
        newContent.contentHash = _contentHash;
        newContent.title = _title;
        newContent.description = _description;
        newContent.category = _category;
        newContent.tags = _tags;
        newContent.baseReward = _baseReward;
        newContent.qualityBonus = _qualityBonus;
        newContent.totalViews = 0;
        newContent.totalEarnings = 0;
        newContent.averageRating = 0;
        newContent.publishedAt = block.timestamp;
        newContent.isActive = true;
        newContent.allowComments = _allowComments;
        newContent.isFeatured = false;

        creatorContents[msg.sender].push(contentId);

        emit ContentPublished(
            contentId,
            msg.sender,
            _contentHash,
            _title,
            _baseReward
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
    ) external {
        Content storage content = contents[_contentId];
        require(
            content.creator == msg.sender,
            "Only creator can update content"
        );
        require(content.isActive, "Content is not active");
        require(bytes(_contentHash).length > 0, "Content hash cannot be empty");

        content.contentHash = _contentHash;
        content.title = _title;
        content.description = _description;

        emit ContentUpdated(_contentId, _contentHash);
    }

    /**
     * @dev 记录阅读
     * @param _contentId 内容ID
     * @param _timeSpent 阅读时间（秒）
     * @param _completed 是否完成阅读
     */
    function recordRead(
        uint256 _contentId,
        uint256 _timeSpent,
        bool _completed
    ) external nonReentrant {
        Content storage content = contents[_contentId];
        require(content.isActive, "Content is not active");
        require(
            msg.sender != content.creator,
            "Creator cannot read own content"
        );
        require(_timeSpent > 0, "Time spent must be greater than 0");

        // 检查是否已经阅读过
        bool alreadyRead = false;
        for (uint i = 0; i < readRecords[_contentId].length; i++) {
            if (readRecords[_contentId][i].reader == msg.sender) {
                alreadyRead = true;
                break;
            }
        }

        if (!alreadyRead) {
            content.totalViews++;
            readerHistory[msg.sender].push(_contentId);
        }

        ReadRecord memory newRecord = ReadRecord({
            reader: msg.sender,
            contentId: _contentId,
            readAt: block.timestamp,
            timeSpent: _timeSpent,
            completed: _completed
        });

        readRecords[_contentId].push(newRecord);

        emit ReadRecorded(_contentId, msg.sender, _timeSpent);
    }

    /**
     * @dev 添加评论
     * @param _contentId 内容ID
     * @param _text 评论内容
     */
    function addComment(uint256 _contentId, string calldata _text) external {
        Content storage content = contents[_contentId];
        require(content.isActive, "Content is not active");
        require(content.allowComments, "Comments not allowed for this content");
        require(bytes(_text).length > 0, "Comment cannot be empty");
        require(
            msg.sender != content.creator,
            "Creator cannot comment on own content"
        );

        _commentIds.increment();
        uint256 commentId = _commentIds.current();

        Comment memory newComment = Comment({
            id: commentId,
            author: msg.sender,
            contentId: _contentId,
            text: _text,
            timestamp: block.timestamp,
            isActive: true
        });

        comments[_contentId].push(newComment);

        emit CommentAdded(_contentId, msg.sender, _text);
    }

    /**
     * @dev 移除评论
     * @param _contentId 内容ID
     * @param _commentId 评论ID
     */
    function removeComment(uint256 _contentId, uint256 _commentId) external {
        Comment[] storage contentComments = comments[_contentId];
        require(_commentId < contentComments.length, "Comment does not exist");

        Comment storage comment = contentComments[_commentId];
        require(comment.isActive, "Comment already removed");
        require(
            comment.author == msg.sender || msg.sender == owner(),
            "Not authorized"
        );

        comment.isActive = false;

        emit CommentRemoved(_contentId, _commentId);
    }

    /**
     * @dev 设置内容为特色内容
     * @param _contentId 内容ID
     * @param _isFeatured 是否为特色内容
     */
    function setFeatured(
        uint256 _contentId,
        bool _isFeatured
    ) external onlyOwner {
        Content storage content = contents[_contentId];
        require(content.isActive, "Content is not active");

        content.isFeatured = _isFeatured;
    }

    /**
     * @dev 停用内容
     * @param _contentId 内容ID
     */
    function deactivateContent(uint256 _contentId) external {
        Content storage content = contents[_contentId];
        require(
            content.creator == msg.sender || msg.sender == owner(),
            "Not authorized"
        );
        require(content.isActive, "Content already deactivated");

        content.isActive = false;

        emit ContentDeactivated(_contentId);
    }

    /**
     * @dev 获取内容信息
     * @param _contentId 内容ID
     * @return 内容结构
     */
    function getContent(
        uint256 _contentId
    ) external view returns (Content memory) {
        return contents[_contentId];
    }

    /**
     * @dev 获取创作者的內容列表
     * @param _creator 创作者地址
     * @return 内容ID数组
     */
    function getCreatorContents(
        address _creator
    ) external view returns (uint256[] memory) {
        return creatorContents[_creator];
    }

    /**
     * @dev 获取读者的阅读历史
     * @param _reader 读者地址
     * @return 内容ID数组
     */
    function getReaderHistory(
        address _reader
    ) external view returns (uint256[] memory) {
        return readerHistory[_reader];
    }

    /**
     * @dev 获取内容的阅读记录
     * @param _contentId 内容ID
     * @return 阅读记录数组
     */
    function getReadRecords(
        uint256 _contentId
    ) external view returns (ReadRecord[] memory) {
        return readRecords[_contentId];
    }

    /**
     * @dev 获取内容的评论
     * @param _contentId 内容ID
     * @return 评论数组
     */
    function getComments(
        uint256 _contentId
    ) external view returns (Comment[] memory) {
        return comments[_contentId];
    }

    /**
     * @dev 更新配置
     * @param _minBaseReward 最小基础奖励
     * @param _maxBaseReward 最大基础奖励
     * @param _maxQualityBonus 最大质量奖励倍数
     */
    function updateConfig(
        uint256 _minBaseReward,
        uint256 _maxBaseReward,
        uint256 _maxQualityBonus
    ) external onlyOwner {
        require(_minBaseReward < _maxBaseReward, "Invalid reward range");
        require(_maxQualityBonus <= 500, "Quality bonus too high"); // 最大500%

        minBaseReward = _minBaseReward;
        maxBaseReward = _maxBaseReward;
        maxQualityBonus = _maxQualityBonus;
    }

    /**
     * @dev 获取内容总数
     * @return 内容总数
     */
    function getContentCount() external view returns (uint256) {
        return _contentIds.current();
    }

    /**
     * @dev 获取评论总数
     * @return 评论总数
     */
    function getCommentCount() external view returns (uint256) {
        return _commentIds.current();
    }
}
