// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import { ERC721A } from "ERC721A/ERC721A.sol";

contract SimpleERC721AToken is ERC721A {
    constructor() ERC721A("Simple 721A", "S721A") {
        
    }  

    function bulkMint(uint256 _quantity) public {
        _safeMint(msg.sender, _quantity);
    }
}