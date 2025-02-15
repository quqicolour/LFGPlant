// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.23;

interface ILFGCollection {
    struct TokenInfo {
        uint8 decimals;
        uint64 createTime;
        uint256 nftId;
        uint256 maxSupply;
        string tokenName;
        string tokenSymbol;
        string content;
        string tokenURI;
        address tokenAddress;
        address author;
    }

    event MetadataUpdate(uint256 indexed tokenId);

    function getTokenInfo(uint256 tokenId) external view returns (TokenInfo memory);

}

