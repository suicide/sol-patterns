// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Token, TokenError, Transfer} from "../Token.sol";

struct Storage {
    uint256 totalSupply;
    mapping(address => uint256) balances;
}

/// @title Token Lib
/// @notice All logic is moved into a library and function injection
/// @dev injected functions are inlined
library TokenLib {
    // ERC-7701
    // keccak256(abi.encode(uint256(keccak256("tokenStorage")) - 1)) & ~bytes32(uint256(0xff))
    bytes32 private constant STORAGE_LOCATION = 0x6ccaea25af72f303f0b4b10bb638d19bb28477bc522662b0db32f648d7435100;

    function _getStorage() internal pure returns (Storage storage $) {
        // solhint-disable no-inline-assembly
        assembly {
            $.slot := STORAGE_LOCATION
        }
        // solhint-enable no-inline-assembly
    }

    function mint(address to, uint256 amount) internal {
        Storage storage $ = _getStorage();
        _mint($, to, amount);
    }

    function _mint(Storage storage $, address to, uint256 amount) internal {
        require(to != address(0), TokenError());

        $.totalSupply += amount;
        $.balances[to] += amount;

        emit Transfer(address(0), to, amount);
    }

    function burn(address from, uint256 amount) internal {
        Storage storage $ = _getStorage();

        __burn($, _balanceOf, from, amount);
    }

    function __burn(
        Storage storage $,
        function (Storage storage, address) view returns (uint256) balanceOf_,
        address from,
        uint256 amount
    ) internal {
        require(from != address(0), TokenError());

        require(balanceOf_($, from) >= amount, TokenError());

        $.balances[from] -= amount;
        $.totalSupply -= amount;

        emit Transfer(from, address(0), amount);
    }

    function transferFrom(address from, address to, uint256 amount) internal {
        Storage storage $ = _getStorage();

        __transferFrom($, _balanceOf, from, to, amount);
    }

    function __transferFrom(
        Storage storage $,
        function (Storage storage, address) view returns (uint256) balanceOf_,
        address from,
        address to,
        uint256 amount
    ) internal {
        require(to != address(0), TokenError());
        require(from != address(0), TokenError());
        require(balanceOf_($, from) >= amount, TokenError());

        $.balances[from] -= amount;
        $.balances[to] += amount;

        emit Transfer(from, to, amount);
    }

    function totalSupply() internal view returns (uint256) {
        Storage storage $ = _getStorage();
        return _totalSupply($);
    }

    function _totalSupply(Storage storage $) internal view returns (uint256) {
        return $.totalSupply;
    }

    function balanceOf(address owner) internal view returns (uint256) {
        Storage storage $ = _getStorage();
        return _balanceOf($, owner);
    }

    function _balanceOf(Storage storage $, address owner) internal view returns (uint256) {
        return $.balances[owner];
    }

    function _doSomething(function (address) external view returns (uint256) balanceOf_, address owner)
        internal
        view
        returns (uint256)
    {
        require(owner != address(0), TokenError());
        return balanceOf_(owner);
    }
}

contract WithFunctions is Token {
    function mint(address to, uint256 amount) external {
        TokenLib.mint(to, amount);
    }

    function burn(address from, uint256 amount) external {
        TokenLib.burn(from, amount);
    }

    function transferFrom(address from, address to, uint256 amount) external {
        TokenLib.transferFrom(from, to, amount);
    }

    function totalSupply() external view returns (uint256) {
        return TokenLib.totalSupply();
    }

    function balanceOf(address owner) external view returns (uint256) {
        return TokenLib.balanceOf(owner);
    }
}
