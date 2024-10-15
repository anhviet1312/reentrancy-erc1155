// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "hardhat/console.sol";

contract NFT is ERC721 {
    uint public tokenId;
    uint public maxSupply = 1000;
 
    uint public constant DEFAULT_PRICE = 1 gwei;
    mapping(address => bool) public addressMinted;
    constructor() ERC721("VulnerableNFT", "VNFT") {}

    function mintNFT() external payable {
        require(DEFAULT_PRICE <= msg.value, "Insufficient payable value");
        require(tokenId < maxSupply, "All tokens have been minted");
        require(!addressMinted[msg.sender], "Address has minted");

        unchecked {
            ++tokenId;
        }
        _safeMint(msg.sender, tokenId - 1);
        
        addressMinted[msg.sender] = true;
    }

    function getTokenId() public view returns (uint) {
        return tokenId;
    }
}
