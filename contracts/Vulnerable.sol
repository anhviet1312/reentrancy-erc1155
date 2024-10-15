// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.0;

// import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
// import "./NFT.sol";
// contract Vulnerable {
//     NFT nft;
//     uint constant DEFAULT_PRICE = 1 gwei;

//     mapping(address => uint256) public depositedNFTs;
//     mapping(address => uint256) public balances;

//     constructor(address nftAddress) {
//         nft = NFT(nftAddress);
//     }

//     function buy() external payable {
//         require(msg.value == DEFAULT_PRICE, "Insufficient ETH to buy NFT");
//         nft.mint(msg.sender);
//         balances[msg.sender] ++;
//     }

//     function depositNFT(uint256 tokenId) external {
//         require(depositedNFTs[msg.sender] == 0, "Already deposited an NFT");
        
//         nft.safeTransferFrom(msg.sender, address(this), tokenId);

//         depositedNFTs[msg.sender] = tokenId;
//         balances[msg.sender] = DEFAULT_PRICE;
//     }

//     function withdraw() external {
//         uint256 tokenId = depositedNFTs[msg.sender];
//         require(tokenId != 0, "No NFT deposited");

//         uint256 amount = balances[msg.sender];
//         require(amount > 0, "No balance to withdraw");
//         payable(msg.sender).transfer(amount);
//         balances[msg.sender] = 0;

//         nft.safeTransferFrom(address(this), msg.sender, tokenId);

//         depositedNFTs[msg.sender] = 0;
//     }

//     function transfer() external {
//         uint amount = balances[msg.sender];
//         require(amount > 0, "No balance to withdraw");
//         balances[msg.sender] = 0;
//     }

// }
