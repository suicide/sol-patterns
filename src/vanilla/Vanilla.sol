// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Token, TokenError, Transfer} from "../Token.sol";

/// @title Vanilla implementation
/// @notice Straight forward impl using local storage
contract Vanilla is Token {
    uint256 private _totalSupply;

    mapping(address => uint256) private _balances;

    function mint(address to, uint256 amount) external {
        require(to != address(0), TokenError());
        _totalSupply += amount;
        _balances[to] += amount;

        emit Transfer(address(0), to, amount);
    }

    function burn(address from, uint256 amount) external {
        require(from != address(0), TokenError());
        require(balanceOf(from) >= amount, TokenError());

        _balances[from] -= amount;
        _totalSupply -= amount;

        emit Transfer(from, address(0), amount);
    }

    function transferFrom(address from, address to, uint256 amount) external {
        require(to != address(0), TokenError());
        require(from != address(0), TokenError());
        require(balanceOf(from) >= amount, TokenError());

        _balances[from] -= amount;
        _balances[to] += amount;

        emit Transfer(from, to, amount);
    }

    function totalSupply() external view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address owner) public view returns (uint256) {
        return _balances[owner];
    }
}
