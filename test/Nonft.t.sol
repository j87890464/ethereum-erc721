// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import {Test, console2} from "forge-std/Test.sol";
import {Nonft} from "../src/Nonft.sol";

contract NonftTest is Test {
    Nonft public nonft;
    address public user1;

    function setUp() public {
        nonft = new Nonft("Don't send NFT to me", "NONFT", "ipfs://bafybeiffsp2cje3lsyagfn6yzpdjfm7n62xmrygnjpu2pq2hczptqqjdnm");
        user1 = makeAddr("user1");
    }

    function test_Mint() public {
        vm.startPrank(user1);
        nonft.mintNonft(user1);
        assertEq(nonft.balanceOf(user1), 1);
        vm.stopPrank();
    }

    function test_TokenURI() public {
        vm.startPrank(user1);
        uint256 tokenId = nonft.mintNonft(user1);
        assertEq(nonft.tokenURI(tokenId), "ipfs://bafybeiffsp2cje3lsyagfn6yzpdjfm7n62xmrygnjpu2pq2hczptqqjdnm");
        vm.stopPrank();
    }
}
