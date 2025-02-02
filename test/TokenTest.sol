// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Test, console} from "forge-std/Test.sol";
import {Token, TokenError, Transfer} from "../src/Token.sol";

abstract contract TokenTest is Test {
    Token public token;

    function testMint(address to, uint256 amount) public {
        vm.assume(to != address(0));

        vm.expectEmit();
        emit Transfer(address(0), to, amount);
        token.mint(to, amount);

        assertEq(amount, token.totalSupply());
        assertEq(amount, token.balanceOf(to));
    }

    function testBurn(address from, uint256 amount) public {
        uint256 supply = 100_000 ether;
        vm.assume(from != address(0));
        vm.assume(amount <= supply);

        token.mint(from, supply);

        vm.expectEmit();
        emit Transfer(from, address(0), amount);
        token.burn(from, amount);

        assertEq(supply - amount, token.totalSupply());
        assertEq(supply - amount, token.balanceOf(from));
    }

    function testTransfer(address from, address to, uint256 amount) public {
        uint256 supply = 100_000 ether;
        vm.assume(from != address(0));
        vm.assume(to != address(0));
        vm.assume(to != from);
        vm.assume(amount <= supply);

        token.mint(from, supply);

        vm.expectEmit();
        emit Transfer(from, to, amount);
        token.transferFrom(from, to, amount);

        assertEq(supply - amount, token.balanceOf(from));
        assertEq(amount, token.balanceOf(to));
    }

    function testTransfers() public {
        uint256 supply = 100_000 ether;
        uint256 n = 1_000;
        uint256 d = 500;

        for (uint256 i = 0; i < n; i++) {
            address to = address(uint160(n + i + d));
            address from = address(uint160(n + i));
            token.mint(from, supply);

            uint256 balanceFrom = token.balanceOf(from);
            uint256 balanceTo = token.balanceOf(to);
            token.transferFrom(from, to, 1 ether);

            assertEq(balanceFrom - 1 ether, token.balanceOf(from));
            assertEq(balanceTo + 1 ether, token.balanceOf(to));
        }
    }
}
