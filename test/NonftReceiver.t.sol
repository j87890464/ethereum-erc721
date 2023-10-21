// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import {Test, console2} from "forge-std/Test.sol";
import {Nonft} from "../src/Nonft.sol";
import {NonftReceiver} from "../src/NonftReceiver.sol";
import {AnotherNft} from "../src/AnotherNft.sol";

contract NonftReceiverTest is Test {
    Nonft public nonft;
    AnotherNft public anotherNft;
    NonftReceiver public nonftReceiver;
    address public user1;
    uint256 public mintedToken;

    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    function setUp() public {
        nonft = new Nonft("Don't send NFT to me", "NONFT", "ipfs://bafybeiffsp2cje3lsyagfn6yzpdjfm7n62xmrygnjpu2pq2hczptqqjdnm");
        anotherNft = new AnotherNft("Another NFT", "AN");
        nonftReceiver = new NonftReceiver(address(nonft));
        user1 = makeAddr("user1");
        mintedToken = anotherNft.mintNft(user1);
    }

    function test_OnERC721Received() public {
        vm.startPrank(user1);
        vm.expectEmit();
        emit Transfer(address(nonftReceiver), user1, mintedToken);
        vm.expectEmit();
        emit Transfer(address(0), user1, 1);
        anotherNft.safeTransferFrom(user1, address(nonftReceiver), mintedToken);
        assertEq(anotherNft.ownerOf(mintedToken), user1);
        assertEq(nonft.balanceOf(user1), 1);
        vm.stopPrank();
    }
}
