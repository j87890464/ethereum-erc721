// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import { Test, console2 } from "forge-std/Test.sol";
import { SimpleEnumerableToken } from "../src/SimpleEnumerableToken.sol";
import { SimpleERC721AToken } from "../src/SimpleERC721AToken.sol";

contract ERC721ATest is Test {
    SimpleEnumerableToken public simpleEnumerableToken;
    SimpleERC721AToken public simpleERC721AToken;
    address public user1;
    address public user2;

    function setUp() public {
        simpleEnumerableToken = new SimpleEnumerableToken();
        simpleERC721AToken = new SimpleERC721AToken();
        user1 = makeAddr("user1");
        user2 = makeAddr("user2");
    }

    function test_Mint_1() public {
        vm.startPrank(user1);
        simpleEnumerableToken.bulkMint(1);
        simpleERC721AToken.bulkMint(1);
        vm.stopPrank();
    }

    function test_Mint_5() public {
        vm.startPrank(user1);
        simpleEnumerableToken.bulkMint(5);
        simpleERC721AToken.bulkMint(5);
        vm.stopPrank();
    }

    function test_Mint_100() public {
        vm.startPrank(user1);
        simpleEnumerableToken.bulkMint(100);
        simpleERC721AToken.bulkMint(100);
        vm.stopPrank();
    }

    function test_Transfer() public {
        test_Mint_100();
        vm.startPrank(user1);
        // 42332
        simpleEnumerableToken.transferFrom(user1, user2, 0);
        // 50307
        simpleERC721AToken.transferFrom(user1, user2, 0);
        // 42332
        simpleEnumerableToken.transferFrom(user1, user2, 49);
        // 178546
        simpleERC721AToken.transferFrom(user1, user2, 49);
        // 41858
        simpleEnumerableToken.transferFrom(user1, user2, 99);
        // 269022
        simpleERC721AToken.transferFrom(user1, user2, 99);
        vm.stopPrank();
    }

    function test_Approve() public {
        test_Mint_100();
        vm.startPrank(user1);
        // 25047
        simpleEnumerableToken.approve(user2, 0);
        // 24969
        simpleERC721AToken.approve(user2, 0);
        // 25047
        simpleEnumerableToken.approve(user2, 49);
        // 133308
        simpleERC721AToken.approve(user2, 49);
        // 25047
        simpleEnumerableToken.approve(user2, 99);
        // 243858
        simpleERC721AToken.approve(user2, 99);
        vm.stopPrank();
    }
}
