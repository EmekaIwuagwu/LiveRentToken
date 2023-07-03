// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract LiveRentToken is ERC20 {
    address private owner;
    mapping(address => uint256) private balances;

    event PropertyReserved(
        string fullName,
        address buyerAddress,
        string phoneNumber,
        string emailAddress,
        bool needToContactLandlord
    );

    constructor() ERC20("LiveRentToken", "LVRT") {
        owner = msg.sender;
        _mint(msg.sender, 1000000000000000000000000); // Initial supply of 1,000,000 LVRT tokens
    }

    // Allow users to deposit tokens into the contract
    function depositTokens(uint256 amount) external {
        require(amount > 0, "Amount must be greater than zero");
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");
        _burn(msg.sender, amount);
        balances[msg.sender] += amount;
    }

    // Allow users to withdraw tokens from the contract
    function withdrawTokens(uint256 amount) external {
        require(amount > 0, "Amount must be greater than zero");
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        _mint(msg.sender, amount);
    }

    // Pay for a property using LiveRentToken
    function payForProperty(address propertyAddress, uint256 amount) external {
        require(amount > 0, "Amount must be greater than zero");
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");
        transfer(propertyAddress, amount);
    }

    // Request a refund to the payer address
    function requestRefund(address payerAddress, uint256 amount) external {
        require(amount > 0, "Amount must be greater than zero");
        require(balanceOf(address(this)) >= amount, "Insufficient contract balance");
        _transfer(address(this), payerAddress, amount);
    }

    // Reserve a property for the buyer/renter
    function reserveProperty(
        string memory fullName,
        string memory phoneNumber,
        string memory emailAddress,
        bool needToContactLandlord
    ) external {
        emit PropertyReserved(fullName, msg.sender, phoneNumber, emailAddress, needToContactLandlord);
    }
}
