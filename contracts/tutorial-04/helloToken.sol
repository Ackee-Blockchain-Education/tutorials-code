// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract HelloToken {
    string private _name;
    string private _symbol;
    uint8 private _decimals;
    uint256 private _totalSupply;

    mapping(address => uint256) private _balances;

    // owner => spender => allowed value
    mapping(address => mapping(address => uint256)) private _allowances;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    constructor(string memory name, string memory symbol, uint8 decimals) {
        _name = name;
        _symbol = symbol;
        _decimals = decimals;

        _mint(msg.sender, 1000 * decimals);
    }

    function name() public view returns(string memory) {
        return _name;
    }

    function symbol() public view returns(string memory) {
        return _symbol;
    }

    function decimals() public view returns(uint8) {
        return _decimals;
    }

    function totalSupply() public view returns(uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view returns(uint256) {
        return _balances[account];
    }

    function allowance(address owner, address spender) public view returns(uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 value) public returns(bool) {
        _allowances[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function transferFrom(address owner, address recipient, uint256 amount) public returns(bool) {
        require(allowance(owner, msg.sender) >= amount, "ERC20: transfer amount exceeds allowance");
        require(balanceOf(owner) >= amount, "ERC20: balance of owner too low");
        _balances[owner] -= amount;
        _balances[recipient] += amount;
        _allowances[owner][msg.sender] -= amount;
        emit Transfer(owner, recipient, amount);
        return true;
    }

    function transfer(address recipient, uint256 amount) public returns(bool) {
        return transferFrom(msg.sender, recipient, amount);
    }

    function _mint(address account, uint256 value) internal {
        _totalSupply += value;
        _balances[account] += value;
        emit Transfer(address(0), account, value);
    }

    function _burn(address account, uint256 value) internal {
        require(_balances[account] >= value, "ERC20: burn amount exceed balance");
        _totalSupply -= value;
        _balances[account] -= value;
        emit Transfer(account, address(0), value);
    }

}
