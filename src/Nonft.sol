// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import { ERC721 } from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

contract Nonft is ERC721, Ownable {
    string private _tokenURI;
    uint256 private _totalSupply;

    constructor(string memory name_, string memory symbol_, string memory tokenURI_) ERC721(name_, symbol_) Ownable(msg.sender) {
        _tokenURI = tokenURI_;
    }

    function mintNonft(address _to) public returns(uint256) {
        uint256 _nextTokenId = totalSupply() + 1;
        _mint(_to, _nextTokenId);
        _totalSupply++;

        return _nextTokenId;
    }

    function totalSupply() public view returns (uint256){
        return _totalSupply;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(ownerOf(tokenId) != address(0), "Invalid tokenId!");

        return _tokenURI;
    }

    function updateTokenURI(string calldata _URI) public onlyOwner {
        _tokenURI = _URI;
    }
}
