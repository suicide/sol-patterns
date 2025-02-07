// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Test, console} from "forge-std/Test.sol";
import {TokenTest} from "./TokenTest.sol";
import {Token, Transfer} from "../src/Token.sol";
import {WithFunctions, Storage, TokenLib} from "../src/withlib/WithFunctions.sol";

contract WithFunctionsTest is TokenTest {
    Storage private s;

    function setUp() public {
        token = new WithFunctions();
    }

    function testBalanceOf(address owner) public {
        assertEq(TokenLib._balanceOf(s, owner), 0);

        // mutations don't seem to be a problem when using a simple storage struct
        s.balances[owner] = 1;
    }

    // static, simple function stub
    function balanceOfStub(Storage storage, address owner) private pure returns (uint256) {
        assertNotEq(owner, address(0));
        return UINT256_MAX;
    }

    function testBurnStub(address from, uint256 amount) public {
        vm.assume(from != address(0));

        s.balances[from] = amount;
        s.totalSupply = UINT256_MAX;

        vm.expectEmit();
        emit Transfer(from, address(0), amount);

        TokenLib.__burn(s, balanceOfStub, from, amount);
    }

    // mock is controlled by state var
    uint256 private _balanceOfMock;

    function balanceOfMock(Storage storage, address owner) private view returns (uint256) {
        assertNotEq(owner, address(0));
        return _balanceOfMock;
    }

    function testBurnMock(address from, uint256 amount) public {
        vm.assume(from != address(0));
        _balanceOfMock = amount;

        s.balances[from] = amount;
        s.totalSupply = UINT256_MAX;

        vm.expectEmit();
        emit Transfer(from, address(0), amount);

        TokenLib.__burn(s, balanceOfMock, from, amount);
    }

    function testExternalContract(address from, uint256 amount) public {
        vm.assume(from != address(0));
        ExternalContract ex = new ExternalContract(amount);

        s.balances[from] = amount;
        s.totalSupply = UINT256_MAX;

        // this function must only accept external functions and cannot inline the call at compile time
        TokenLib._doSomething(ex.balanceOf, from);
    }
}

contract ExternalContract {
    uint256 private balance;

    constructor(uint256 _balance) {
        balance = _balance;
    }

    function balanceOf(address owner) public view returns (uint256) {
        require(owner != address(0));
        return balance;
    }
}
