// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import {Test, console2} from "forge-std/Test.sol";
import {RandomMintNft} from "../src/RandomMintNft.sol";
import {VRFv2Consumer} from "../src/VRFv2Consumer.sol";

contract RandomMintNftTest is Test {
    RandomMintNft public randomMintNft;
    address public user1;
    uint256 public sepoliaFork;
    uint256 public vrfRequestID;
    string public tokenURI;
    string public unrevealedTokenURI;

    function setUp() public {
        string memory sepoliaUrl = vm.rpcUrl("sepolia");
        sepoliaFork = vm.createFork(sepoliaUrl);
        vrfRequestID = 2434958413822996221281407648824320680268504669445970203830331396250695750904;
        tokenURI = "ipfs://bafybeiffsp2cje3lsyagfn6yzpdjfm7n62xmrygnjpu2pq2hczptqqjdnm";
        unrevealedTokenURI = "ipfs://Qmdc24K1yFzysWTYUHfFbYbNywuggHX1ijqcTCqS4Q35Zz";
        vm.selectFork(sepoliaFork);
        user1 = makeAddr("user1");
        vm.prank(user1);
        randomMintNft = new RandomMintNft("Random Mint NFT", "RND", unrevealedTokenURI, tokenURI, 0xF51353449dCc09f9A0D3Ec0eF72a13017D5e6eCF);
    }

    function test_Mint() public {
        vm.startPrank(user1);
        randomMintNft.mint(user1);
        assertEq(randomMintNft.balanceOf(user1), 1);
        vm.stopPrank();
    }

    function test_BulkMint() public {
        vm.startPrank(user1);
        for (uint16 i = 0; i < 500; i++) {
            randomMintNft.mint(user1);
        }
        assertEq(randomMintNft.balanceOf(user1), 500);
        vm.stopPrank();
    }

    function test_Fail_OverMint() public {
        vm.startPrank(user1);
        for (uint16 i = 0; i < 500; i++) {
            randomMintNft.mint(user1);
        }
        vm.expectRevert("over mint");
        randomMintNft.mint(user1);
        vm.stopPrank();
    }

    function test_RandomMint() public {
        vm.startPrank(user1);
        randomMintNft.setRandomNums(vrfRequestID);
        randomMintNft.randomMint(user1);
        assertEq(randomMintNft.balanceOf(user1), 1);
        vm.stopPrank();
    }

    function test_RandomBulkMint() public {
        vm.startPrank(user1);
        randomMintNft.setRandomNums(vrfRequestID);
        for (uint16 i = 0; i < 500; i++) {
            randomMintNft.randomMint(user1);
        }
        assertEq(randomMintNft.balanceOf(user1), 500);
        vm.stopPrank();
    }

    function test_Fail_OverRandomMint() public {
        vm.startPrank(user1);
        randomMintNft.setRandomNums(vrfRequestID);
        for (uint16 i = 0; i < 500; i++) {
            randomMintNft.randomMint(user1);
        }
        vm.expectRevert("over mint");
        randomMintNft.randomMint(user1);
        vm.stopPrank();
    }

    function test_MixedMint() public {
        vm.startPrank(user1);
        randomMintNft.setRandomNums(vrfRequestID);
        for (uint16 i = 0; i < 250; i++) {
            randomMintNft.mint(user1);
            randomMintNft.randomMint(user1);
        }
        assertEq(randomMintNft.balanceOf(user1), 500);
        vm.stopPrank();
    }

    function test_TokenURI() public {
        vm.startPrank(user1);
        uint256 tokenId = randomMintNft.mint(user1);
        assertEq(randomMintNft.tokenURI(tokenId), unrevealedTokenURI);
        randomMintNft.toggleRevealStatus();
        assertEq(randomMintNft.revealed(), true);
        assertEq(randomMintNft.tokenURI(tokenId), tokenURI);
        vm.stopPrank();
    }
}
