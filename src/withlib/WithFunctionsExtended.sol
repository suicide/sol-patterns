// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Token} from "../Token.sol";
import {TokenLib, Storage} from "./WithFunctions.sol";

/// @title Extended Token Lib
/// @notice All logic is moved into a library
/// @dev ExtendedLib overrides functions and re-composes them without overhead as everything gets inlined
library TokenExtendedLib {
    function transferFrom(address from, address to, uint256 amount) internal {
        Storage storage $ = TokenLib._getStorage();
        TokenLib.__transferFrom($, TokenLib._balanceOf, from, to, amount);
    }

    event SomeEvent(uint256 indexed val);

    function justDoIt(address addr, uint256 val) internal returns (uint256) {
        Storage storage $ = TokenLib._getStorage();

        return doIt($, TokenLib._balanceOf, addr, val, funcA, funcB, funcC, funcD, funcE, funcF, funcG, funcH, funcH);
    }

    function doIt(
        Storage storage $,
        function (Storage storage, address) view returns (uint256) balanceOf_,
        address addr,
        uint256 val,
        function (Storage storage,function (Storage storage, address) view returns (uint256), address) returns (uint256)
            fa,
        function (uint256) returns (uint256) fb,
        function (uint256) returns (uint256) fc,
        function (uint256) returns (uint256) fd,
        function (uint256) returns (uint256) fe,
        function (uint256) returns (uint256) ff,
        function (uint256) returns (uint256) fg,
        function (uint256) returns (uint256) fh,
        function (uint256) returns (uint256) fi
    ) internal returns (uint256) {
        uint256 v = fa($, balanceOf_, addr);
        uint256 a = fb(val);
        uint256 b = fc(a);
        uint256 c = fd(b);

        uint256 x = v + a + $.totalSupply;
        $.totalSupply = x;

        uint256 d = fe(c);
        uint256 e = ff(d);
        uint256 f = fg(e);
        uint256 y = e + x + v - 2;
        uint256 g = fh(f);
        uint256 i = fi(g);

        uint256 z = d + x + y + $.totalSupply;

        $.balances[addr] = v + g + i + (d + f + z - x);
        return g + g + a + b + c + (val + v + y - d) + z - d + $.totalSupply + $.balances[addr];
    }

    function funcA(
        Storage storage $,
        function (Storage storage, address) view returns (uint256) balanceOf_,
        address addr
    ) internal returns (uint256) {
        uint256 v = balanceOf_($, addr);
        emit SomeEvent(v);
        return v;
    }

    function funcB(uint256 v) internal returns (uint256) {
        uint256 r = v + v + 1;
        emit SomeEvent(r);
        return r;
    }

    function funcC(uint256 v) internal returns (uint256) {
        uint256 r = v / 2 + 1;
        emit SomeEvent(r);
        return r;
    }

    function funcD(uint256 v) internal returns (uint256) {
        uint256 r = v + v + 1;
        emit SomeEvent(r);
        return r;
    }

    function funcE(uint256 v) internal returns (uint256) {
        uint256 r = v / 2 + 1 + v + v;
        emit SomeEvent(r);
        return r;
    }

    function funcF(uint256 v) internal returns (uint256) {
        uint256 r = v * 2 + 1 + v + v;
        emit SomeEvent(r);
        return r;
    }

    function funcG(uint256 v) internal returns (uint256) {
        uint256 r = v * 3 + v;
        emit SomeEvent(r);
        return r;
    }

    function funcH(uint256 v) internal returns (uint256) {
        uint256 r = v * 3 + 9;
        emit SomeEvent(r);
        return r;
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

    function justDoIt(address owner, uint256 val) external returns (uint256) {
        return TokenExtendedLib.justDoIt(owner, val);
    }
}
