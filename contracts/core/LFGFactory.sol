// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.23;

import {LFGCollection} from "./LFGCollection.sol";

contract LFGFactory {

    uint64 public CollectionId;
    address private Governance;   

    constructor(address _Governance) {
        Governance = _Governance;
    }

    struct CollectionInfo{
        uint64 CollectionId;
        address CollectionAddress;
        uint64 createTime;
        address creator;
    }

    mapping(address => mapping(uint32 => CollectionInfo[])) public UserCollectionInfo;

    mapping(address => uint32) public UserCollectionCount;

    mapping(uint64 => address) public IdToCollection;

    event CollectionCreated(address indexed author, uint64 indexed collectionId, address indexed collectionAddress);

    function createCollection(string memory name, string memory symbol) external {
        address collection = address(
            new LFGCollection{
                salt: keccak256(
                    abi.encodePacked(msg.sender, symbol, CollectionId)
                )
            }(msg.sender, Governance, name, symbol)
        );
        IdToCollection[CollectionId] = collection;
        UserCollectionInfo[msg.sender][UserCollectionCount[msg.sender]].push(
            CollectionInfo({
                CollectionId: CollectionId,
                CollectionAddress: collection,
                createTime: uint64(block.timestamp),
                creator: msg.sender
            })
        );
        if(UserCollectionInfo[msg.sender][UserCollectionCount[msg.sender]].length >= 9){
            UserCollectionCount[msg.sender]++;
        }
        emit CollectionCreated(msg.sender, CollectionId, collection);
        CollectionId++;
        require(collection != address(0));
    }
}
