// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.23;

contract Governance {
    address public owner;
    address public manager;
    address private feeReceiver;
    uint8 public fee;
    uint8 public createFee;

    constructor(address _owner, address _manager, address _feeReceiver, uint8 _fee) {
        owner = _owner;
        manager = _manager;
        feeReceiver = _feeReceiver;
        fee = _fee;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Non owner");
        _;
    }

    modifier onlyManager() {
        require(msg.sender == manager, "Non manager");
        _;
    }

    receive() external payable {}

    function setOwner(address _owner) public onlyOwner {
        owner = _owner;
    }

    function setManager(address _manager) public onlyOwner {
        manager = _manager;
    }

    function setFeeReceiver(address _feeReceiver) public onlyOwner {
        feeReceiver = _feeReceiver;
    }

    function setFee(uint8 _fee) public onlyOwner {
        fee = _fee;
    }

    function setCreateFee(uint8 _createFee) public onlyManager {
        createFee = _createFee;
    }

    function getFeeReceiver() public view returns (address _feeReceiver) {
        if(feeReceiver == address(0)) {
            _feeReceiver = address(this);
        } else {
            _feeReceiver = feeReceiver;
        }
    }

    function withdraw() public onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No balance");
        (bool success, ) = payable(owner).call{value: balance}("");
        require(success, "Withdraw failed");
    }

}
