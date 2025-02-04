// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

/// @title Token interface
/// @dev simple implementation of a token
interface Token {
    function mint(address to, uint256 amount) external;

    function burn(address to, uint256 amount) external;

    function transferFrom(address from, address to, uint256 amount) external;

    function totalSupply() external view returns (uint256);

    function balanceOf(address owner) external view returns (uint256);
}

error TokenError();

event Transfer(address indexed from, address indexed to, uint256 indexed amount);
