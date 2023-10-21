// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import { ERC721 } from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract AnotherNft is ERC721 {
    uint256 private _totalSupply;

    constructor(string memory name_, string memory symbol_) ERC721(name_, symbol_) {
    }

    function mintNft(address _to) public returns(uint256) {
        uint256 _nextTokenId = totalSupply() + 1;
        _mint(_to, _nextTokenId);
        _totalSupply++;

        return _nextTokenId;
    }

    function totalSupply() public view returns (uint256){
        return _totalSupply;
    }
}
