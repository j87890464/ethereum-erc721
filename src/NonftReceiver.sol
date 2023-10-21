// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "./Nonft.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NonftReceiver is IERC721Receiver, Ownable {
    address private _nonftAddr;
    Nonft private nonft;

    constructor(address addr_) Ownable(msg.sender) {
        _nonftAddr = addr_;
    }

    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external override returns (bytes4) {
        if (msg.sender != _nonftAddr) {
            IERC721 wrongToken = IERC721(msg.sender);
            wrongToken.transferFrom(address(this), from, tokenId);
            nonft = Nonft(_nonftAddr);
            nonft.mintNonft(from);
        }

        return this.onERC721Received.selector;
    }

    function updateNonft(address _addr) public onlyOwner {
        _nonftAddr = _addr;
    }
}