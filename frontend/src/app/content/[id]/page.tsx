import {
  BookOpen,
  Clock,
  Eye,
  Star,
  User,
  Calendar,
  Tag,
  Award,
} from "lucide-react";
import Navigation from "../../../components/Navigation";
import {
  formatNumber,
  formatDate,
  calculateReadingTime,
} from "../../../lib/utils";

export default function ContentPage({ params }: { params: { id: string } }) {
  // Mock content data - in real app, fetch from API/blockchain
  const content = {
    id: params.id,
    title: "Complete Solidity Smart Contract Development Guide",
    author: "Alice Crypto",
    authorAddress: "0x1234...5678",
    description:
      "A comprehensive guide to building, testing, and deploying smart contracts on Ethereum and Monad blockchain. Learn Solidity from basics to advanced patterns.",
    content: `
# Complete Solidity Smart Contract Development Guide

## Introduction

Welcome to the comprehensive guide on Solidity smart contract development. This guide will take you from the basics of Solidity to advanced contract patterns and security best practices.

## What is Solidity?

Solidity is a high-level programming language designed for implementing smart contracts on the Ethereum blockchain. It's statically typed, supports inheritance, and has a rich set of built-in data types.

## Basic Syntax

### Contract Structure

\`\`\`solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MyContract {
    // State variables
    uint256 public value;
    
    // Events
    event ValueChanged(uint256 newValue);
    
    // Functions
    function setValue(uint256 _value) public {
        value = _value;
        emit ValueChanged(_value);
    }
}
\`\`\`

## Data Types

Solidity provides several data types:

- **Value Types**: bool, int, uint, address, bytes
- **Reference Types**: string, arrays, structs, mappings
- **Function Types**: function types and modifiers

## Security Considerations

### Reentrancy Attacks

One of the most common vulnerabilities in smart contracts is reentrancy attacks. Always follow the checks-effects-interactions pattern.

\`\`\`solidity
// Secure pattern
function withdraw() public {
    uint256 amount = balances[msg.sender];
    require(amount > 0);
    
    balances[msg.sender] = 0; // Effects first
    
    (bool success, ) = msg.sender.call{value: amount}(""); // Interactions last
    require(success);
}
\`\`\`

## Testing and Deployment

### Testing with Foundry

Foundry is a fast, portable and modular toolkit for Ethereum application development.

\`\`\`solidity
// Test file
contract MyContractTest is Test {
    MyContract public contract;
    
    function setUp() public {
        contract = new MyContract();
    }
    
    function testSetValue() public {
        contract.setValue(42);
        assertEq(contract.value(), 42);
    }
}
\`\`\`

## Advanced Patterns

### Upgradeable Contracts

Using the OpenZeppelin upgradeable contracts pattern:

\`\`\`solidity
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract MyUpgradeableContract is Initializable, OwnableUpgradeable {
    function initialize() public initializer {
        __Ownable_init();
    }
}
\`\`\`

## Conclusion

Smart contract development requires careful attention to security, gas optimization, and best practices. Always test thoroughly and consider having your contracts audited before mainnet deployment.

Remember: Code is law on the blockchain!
    `,
    category: "Blockchain",
    tags: ["solidity", "smart-contracts", "ethereum", "blockchain", "web3"],
    readTime: "45 min",
    views: 1234,
    rating: 4.8,
    reward: "50 KMT",
    publishedDate: "2024-01-15",
    lastUpdated: "2024-01-20",
  };

  return (
    <div className="min-h-screen bg-gray-50">
      <Navigation />

      {/* Content Header */}
      <header className="bg-white border-b border-gray-200">
        <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
          <div className="mb-6">
            <span className="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-blue-100 text-blue-800">
              {content.category}
            </span>
          </div>

          <h1 className="text-3xl sm:text-4xl font-bold text-gray-900 mb-4">
            {content.title}
          </h1>

          <p className="text-lg text-gray-600 mb-6">{content.description}</p>

          {/* Content Meta */}
          <div className="flex flex-wrap items-center gap-6 text-sm text-gray-500">
            <div className="flex items-center gap-2">
              <User className="w-4 h-4" />
              <span>{content.author}</span>
              <span className="text-xs bg-gray-100 px-2 py-1 rounded">
                {content.authorAddress}
              </span>
            </div>

            <div className="flex items-center gap-2">
              <Calendar className="w-4 h-4" />
              <span>Published {formatDate(content.publishedDate)}</span>
            </div>

            <div className="flex items-center gap-2">
              <Clock className="w-4 h-4" />
              <span>{content.readTime}</span>
            </div>

            <div className="flex items-center gap-2">
              <Eye className="w-4 h-4" />
              <span>{formatNumber(content.views)} views</span>
            </div>

            <div className="flex items-center gap-2">
              <Star className="w-4 h-4 text-yellow-400 fill-current" />
              <span>{content.rating}</span>
            </div>
          </div>

          {/* Tags */}
          <div className="flex flex-wrap gap-2 mt-4">
            {content.tags.map((tag) => (
              <span
                key={tag}
                className="inline-flex items-center px-2 py-1 rounded-md text-xs font-medium bg-gray-100 text-gray-800"
              >
                <Tag className="w-3 h-3 mr-1" />
                {tag}
              </span>
            ))}
          </div>
        </div>
      </header>

      {/* Content Body */}
      <main className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="bg-white rounded-lg shadow-sm border border-gray-200 p-8">
          {/* Reading Progress */}
          <div className="mb-8 p-4 bg-blue-50 rounded-lg">
            <div className="flex items-center justify-between mb-2">
              <span className="text-sm font-medium text-blue-900">
                Reading Progress
              </span>
              <span className="text-sm text-blue-700">0%</span>
            </div>
            <div className="w-full bg-blue-200 rounded-full h-2">
              <div
                className="bg-blue-600 h-2 rounded-full"
                style={{ width: "0%" }}
              ></div>
            </div>
          </div>

          {/* Content */}
          <div className="prose prose-lg max-w-none">
            <div className="whitespace-pre-wrap font-mono text-sm leading-relaxed">
              {content.content}
            </div>
          </div>

          {/* Reading Actions */}
          <div className="mt-8 pt-8 border-t border-gray-200">
            <div className="flex flex-col sm:flex-row gap-4">
              <button className="flex-1 bg-gradient-to-r from-blue-600 to-purple-600 text-white py-3 px-6 rounded-lg font-semibold hover:from-blue-700 hover:to-purple-700 transition-all duration-200 flex items-center justify-center gap-2">
                <BookOpen className="w-5 h-5" />
                Complete Reading
              </button>

              <button className="flex-1 border-2 border-gray-300 text-gray-700 py-3 px-6 rounded-lg font-semibold hover:border-gray-400 hover:bg-gray-50 transition-all duration-200 flex items-center justify-center gap-2">
                <Star className="w-5 h-5" />
                Rate Content
              </button>
            </div>

            <div className="mt-4 text-center">
              <div className="flex items-center justify-center gap-2 text-sm text-gray-600">
                <Award className="w-4 h-4 text-yellow-500" />
                <span>Earn {content.reward} for completing this content</span>
              </div>
            </div>
          </div>
        </div>
      </main>
    </div>
  );
}
