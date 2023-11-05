// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import { ERC721Enumerable } from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import { ERC721 } from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract SimpleEnumerableToken is ERC721Enumerable {

    constructor() ERC721("SimpleEnumerableToken", "SET") {

    }

    function bulkMint(uint256 _quantity) public {
        uint256 _totalSupply = totalSupply();
        for(uint256 i; i < _quantity; ++i) {
            _safeMint(msg.sender, _totalSupply + i);
        }
    }
}