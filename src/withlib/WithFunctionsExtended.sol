// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Token, TokenError, Transfer} from "../Token.sol";
import {TokenLib, Storage} from "./WithFunctions.sol";

/// @title Extended Token Lib
/// @notice All logic is moved into a library
/// @dev ExtendedLib overrides functions and re-composes them without overhead as everything gets inlined
library TokenExtendedLib {
    function transferFrom(address from, address to, uint256 amount) internal {
        Storage storage $ = TokenLib._getStorage();
        TokenLib.__transferFrom($, TokenLib._balanceOf, from, to, amount);
    }
}

contract WithFunctionsExtended is Token {
    function mint(address to, uint256 amount) external {
        TokenLib.mint(to, amount);
    }

    function burn(address from, uint256 amount) external {
        TokenLib.burn(from, amount);
    }

    function transferFrom(address from, address to, uint256 amount) external {
        TokenExtendedLib.transferFrom(from, to, amount);
    }

    function totalSupply() external view returns (uint256) {
        return TokenLib.totalSupply();
    }

    function balanceOf(address owner) external view returns (uint256) {
        return TokenLib.balanceOf(owner);
    }
}
