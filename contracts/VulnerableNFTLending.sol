// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "./NFT1.sol";
contract VulnerableNFTLending {
    struct Loan {
        address borrower;
        uint nftId;
        uint loanAmount;
        bool active;
    }

    NFT1 public nftContract;
    uint public totalLoans;
    mapping(uint => Loan) public loans;

    constructor(address _nftContract) {
        nftContract = NFT1(_nftContract);
    }

    // Borrow ETH using NFT as collateral
    function borrow(uint _nftId, uint _loanAmount) external {
        // require(nftContract.ownerOf(_nftId) == msg.sender, "Not the owner");
        // require(loans[_nftId].active == false, "Loan already active");

        nftContract.safeTransferFrom(msg.sender, address(this), _nftId);
        // (bool success, ) = msg.sender.call{value: _loanAmount}("");
        // require(success, "can not send eth");

        // loans[_nftId] = Loan(msg.sender, _nftId, _loanAmount, true);
        // totalLoans++;
    }

    // Repay loan and reclaim NFT
    function repay(uint _nftId) external payable {
        Loan memory loan = loans[_nftId];
        require(loan.active, "No active loan");
        require(msg.value == loan.loanAmount, "Incorrect repayment");

        loans[_nftId].active = false;
        nftContract.safeTransferFrom(address(this), loan.borrower, loan.nftId);
    }

    receive() external payable {}
}
