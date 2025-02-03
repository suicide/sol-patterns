// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Token, TokenError, Transfer} from "../Token.sol";

/// @title Token Lib
/// @notice All logic is moved into a library
/// @dev optimizes 'internal' calls
library TokenLib {
    struct Storage {
        uint256 totalSupply;
        mapping(address => uint256) balances;
    }

    // ERC-7701
    // keccak256(abi.encode(uint256(keccak256("tokenStorage")) - 1)) & ~bytes32(uint256(0xff))
    bytes32 private constant STORAGE_LOCATION = 0x6ccaea25af72f303f0b4b10bb638d19bb28477bc522662b0db32f648d7435100;

    function _getStorage() private pure returns (Storage storage $) {
        // solhint-disable no-inline-assembly
        assembly {
            $.slot := STORAGE_LOCATION
        }
        // solhint-enable no-inline-assembly
    }

    function mint(address to, uint256 amount) internal {
        require(to != address(0), TokenError());

        Storage storage $ = _getStorage();
        $.totalSupply += amount;
        $.balances[to] += amount;

        emit Transfer(address(0), to, amount);
    }

    function burn(address from, uint256 amount) internal {
        require(from != address(0), TokenError());

        Storage storage $ = _getStorage();

        require(_balanceOf($, from) >= amount, TokenError());

        $.balances[from] -= amount;
        $.totalSupply -= amount;

        emit Transfer(from, address(0), amount);
    }

    function transferFrom(address from, address to, uint256 amount) internal {
        require(to != address(0), TokenError());
        require(from != address(0), TokenError());

        Storage storage $ = _getStorage();

        _transferFrom($, from, to, amount);
    }

    function _transferFrom(Storage storage $, address from, address to, uint256 amount) internal {
        require(_balanceOf($, from) >= amount, TokenError());

        $.balances[from] -= amount;
        $.balances[to] += amount;

        emit Transfer(from, to, amount);
    }

    function totalSupply() internal view returns (uint256) {
        Storage storage $ = _getStorage();
        return $.totalSupply;
    }

    function balanceOf(address owner) internal view returns (uint256) {
        Storage storage $ = _getStorage();
        return _balanceOf($, owner);
    }

    function _balanceOf(Storage storage $, address owner) internal view returns (uint256) {
        return $.balances[owner];
    }
}

contract WithLib2 is Token {
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
