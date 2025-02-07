// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Token, TokenError, Transfer} from "../Token.sol";

type Amount is uint256;

library AmountLib {
    function add(Amount a, Amount b) internal pure returns (Amount) {
        return Amount.wrap(Amount.unwrap(a) + Amount.unwrap(b));
    }

    function sub(Amount a, Amount b) internal pure returns (Amount) {
        return Amount.wrap(Amount.unwrap(a) - Amount.unwrap(b));
    }
}

/// @title Token Lib
/// @notice All logic is moved into a library
/// @dev uses type aliases and lib functions
library TokenLib {
    using AmountLib for Amount;

    struct Storage {
        Amount totalSupply;
        mapping(address => Amount) balances;
    }

    // ERC-7701
    // keccak256(abi.encode(uint256(keccak256("tokenStorage")) - 1)) & ~bytes32(uint256(0xff))
    // solhint-disable-next-line const-name-snakecase
    bytes32 private constant StorageLocation = 0x6ccaea25af72f303f0b4b10bb638d19bb28477bc522662b0db32f648d7435100;

    function _getStorage() private pure returns (Storage storage $) {
        // solhint-disable no-inline-assembly
        assembly {
            $.slot := StorageLocation
        }
        // solhint-enable no-inline-assembly
    }

    function mint(address to, uint256 amount) internal {
        Amount a = Amount.wrap(amount);
        require(to != address(0), TokenError());

        Storage storage $ = _getStorage();
        $.totalSupply = $.totalSupply.add(a);
        $.balances[to] = $.balances[to].add(a);

        emit Transfer(address(0), to, amount);
    }

    function burn(address from, uint256 amount) internal {
        Amount a = Amount.wrap(amount);
        require(from != address(0), TokenError());
        require(balanceOf(from) >= amount, TokenError());

        Storage storage $ = _getStorage();
        $.balances[from] = $.balances[from].sub(a);
        $.totalSupply = $.totalSupply.sub(a);

        emit Transfer(from, address(0), amount);
    }

    function transferFrom(address from, address to, uint256 amount) internal {
        Amount a = Amount.wrap(amount);
        require(to != address(0), TokenError());
        require(from != address(0), TokenError());
        require(balanceOf(from) >= amount, TokenError());

        Storage storage $ = _getStorage();
        $.balances[from] = $.balances[from].sub(a);
        $.balances[to] = $.balances[to].add(a);

        emit Transfer(from, to, amount);
    }

    function totalSupply() internal view returns (uint256) {
        Storage storage $ = _getStorage();
        return Amount.unwrap($.totalSupply);
    }

    function balanceOf(address owner) internal view returns (uint256) {
        Storage storage $ = _getStorage();
        return Amount.unwrap($.balances[owner]);
    }
}

contract WithTypes is Token {
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
