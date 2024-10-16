// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFT1 is ERC721("NFT1", "NFT1") {
    function mint(address to, uint tokenId) external {
        _mint(to, tokenId);
    }
}
