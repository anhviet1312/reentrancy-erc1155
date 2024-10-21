// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";




contract VulnerableVault is ERC1155 {

    struct LockAsset {
        uint256 fnftId;
        uint256 depositAmount;
    }
   // mapping(uint256 => uint256) public depositAmount;
    uint256 public fnftId;
    constructor() ERC1155("") {}



    // Mint new FNFT
    function mintFNFT(uint256 quantity, uint256 depositAmount) external payable{
        uint256 totalDeposit = depositAmount * quantity;
        require(totalDeposit == msg.value, "not equal amount");
        _mint(msg.sender, ++fnftId, quantity, "");
    }


    function depositAdditionalToFNFT(uint256 quantity, uint256 depositAmount) external {
        safeTransferFrom(msg.sender, address(this), fnftId, 1, "");
    }

    // function withdraw() external {
    //     uint256 amount = depositAmount[fnftId];
    //     depositAmount[fnftId] = 0;
    //     payable(msg.sender).transfer(amount);
    // }

    receive() external payable {}
}
