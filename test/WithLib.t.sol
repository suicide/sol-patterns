// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Test, console} from "forge-std/Test.sol";
import {TokenTest} from "./TokenTest.sol";
import {Token} from "../src/Token.sol";
import {WithLib} from "../src/withlib/WithLib.sol";

contract WithLibTest is TokenTest {
    function setUp() public {
        token = new WithLib();
    }
}
