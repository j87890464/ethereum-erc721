// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import { ERC721 } from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/vrf/VRFConsumerBaseV2.sol";
import "@chainlink/contracts/src/v0.8/shared/access/ConfirmedOwner.sol";

contract RandomMintNft is ERC721, Ownable {
    uint16 public constant CAPPED_SUPPLY = 500;
    uint16 private _totalSupply;
    bool public revealed;
    address private _vrfV2Consumer;
    string private _tokenURI;
    string private _unrevealedTokenURI;
    uint16[] private _remainingTokenIDs;
    uint256[] public randomNums;

    constructor(string memory name_, string memory symbol_, string memory unrevealedTokenURI_, string memory tokenURI_, address vrfV2Consumer_) ERC721(name_, symbol_) Ownable(msg.sender) {
        _tokenURI = tokenURI_;
        _unrevealedTokenURI = unrevealedTokenURI_;
        _vrfV2Consumer = vrfV2Consumer_;
        _remainingTokenIDs.push(1);
        for (uint16 i = 0; i < CAPPED_SUPPLY - 1; i++) {
            _remainingTokenIDs.push(CAPPED_SUPPLY - i);
        }
    }

    function setRandomNums(uint256 _requestID) public onlyOwner {
        (bool success, bytes memory data) = _vrfV2Consumer.call(abi.encodeWithSignature("getRequestStatus(uint256)", _requestID));
        require(success, "_vrfV2Consumer.getRequestStatus() failed");
        (bool fullfilled, uint256[] memory randomWords) = abi.decode(data, (bool, uint256[]));
        require(fullfilled, "not fullfilled");
        randomNums = randomWords;
    }

    function mint(address _to) public returns(uint16) {
        require(++_totalSupply <= CAPPED_SUPPLY, "over mint");
        uint16 _nextTokenID = _remainingTokenIDs[0];
        _updateRemainingTokenIDs(0);
        _mint(_to, _nextTokenID);
        
        return _nextTokenID;
    }

    function randomMint(address _to) public returns(uint16) {
        require(++_totalSupply <= CAPPED_SUPPLY, "over mint");
        uint16 _index;
        if ((CAPPED_SUPPLY - _totalSupply) > 0) {
            _index = _roll(CAPPED_SUPPLY - _totalSupply);
        } else {
            _index = 0;
        }
        uint16 _nextTokenID = _remainingTokenIDs[_index];
        _updateRemainingTokenIDs(_index);
        _mint(_to, _nextTokenID);
        
        return _nextTokenID;
    }

    function totalSupply() public view returns (uint256){
        return _totalSupply;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(ownerOf(tokenId) != address(0), "Invalid tokenId!");
        if (revealed) {
            return _tokenURI;
        } else {
            return _unrevealedTokenURI;
        }
    }

    function updateTokenURI(string calldata _URI) public onlyOwner {
        _tokenURI = _URI;
    }

    function toggleRevealStatus() public onlyOwner {
        revealed = !revealed;
    }

    function _updateRemainingTokenIDs(uint16 _usedIndex) private {
        _remainingTokenIDs[_usedIndex] = _remainingTokenIDs[_remainingTokenIDs.length - 1];
        _remainingTokenIDs.pop();
    }

    function _roll(uint16 _range) private view returns(uint16) {
        uint16 _index = (uint16)(randomNums[_totalSupply % 100] % _range);

        return _index;
    }
}
