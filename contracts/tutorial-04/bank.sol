// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

struct Account {
    string name;
    uint256 balance;
}

contract SimpleBank {
    uint256 constant internal MIN_DEPOSIT = 1 ether;
    bool immutable licensed;
    address public owner;
    mapping(address => Account) public accounts;

    constructor(bool _licensed) {
        owner = msg.sender;
        licensed = _licensed;
    }

    error DepositTooLow();
    event AccountCreated(address indexed account, string name);
    event Deposit(address indexed account, uint256 amount);

    function createAccount(string calldata name) external {
        Account memory newAccount = Account({name: name, balance: 0});
        accounts[msg.sender] = newAccount;
        emit AccountCreated(msg.sender, name);
    }

    modifier onlyApprovedValue() {
        if (licensed) require(msg.value >= MIN_DEPOSIT, DepositTooLow());
        _;
    }

    function deposit() external payable onlyApprovedValue returns (uint256) {
        accounts[msg.sender].balance += msg.value;
        uint256 x = accounts[msg.sender].balance;
        emit Deposit(msg.sender, msg.value);
        return x;
    }
}
