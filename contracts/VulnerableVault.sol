// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract VulnerableVault is ERC1155 {

    struct LockAsset {
        uint256 quantity;
        uint256 depositAmount;
    }

    mapping(uint256 id => uint256 amount) public records;
    uint256 public fnftId = 1;
    constructor() ERC1155("") {}

    // Mint new FNFT
    function mintFNFT(uint256 quantity, uint256 amount) external payable{
        uint256 totalDeposit = amount * quantity;
        require(totalDeposit == msg.value, "not equal amount");
        records[fnftId] = amount;
        _mint(msg.sender, fnftId, quantity, "");
        ++fnftId;
    }

    function depositAdditionalToFNFT(uint256 targetFnftId, uint256 quantity, uint256 depositAmount) external payable{
        require(msg.value == quantity * depositAmount, "Not equal value");
        uint256 currentQuantity = balanceOf(msg.sender, targetFnftId);
        require(currentQuantity > 0, "record not exist");
        require(currentQuantity > quantity, "current quantity should be larger than additional quantity");
        _burn(msg.sender, targetFnftId, quantity);
        records[fnftId] = records[targetFnftId] + depositAmount;
        uint256 newId = fnftId++;
        _mint(msg.sender, newId, quantity, "");
    }

    function withdraw(uint256 targetFnftId) external{        
        uint256 totalFnft = balanceOf(msg.sender, targetFnftId);
        uint256 valueWithdraw = records[targetFnftId] * totalFnft;
        records[targetFnftId] = 0;
        _burn(msg.sender, targetFnftId, totalFnft);
        (bool success, ) = address(this).call{value: valueWithdraw}("");
        require(success, "can not withdraw");
    }

    receive() external payable {}
}
