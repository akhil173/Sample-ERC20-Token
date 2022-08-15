// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts@4.7.3/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts@4.7.3/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts@4.7.3/access/Ownable.sol";

contract SampleToken is ERC20, ERC20Burnable, Ownable {
    uint256 public totalCoinSupply;
    mapping(address => bool) public allowedAddresses;
    constructor() ERC20("SampleToken", "STK") {
        _mint(msg.sender, 10000 * 10 ** decimals());
        totalCoinSupply = totalSupply();
    }

    /*Modified to check if user is blocked from transacting token*/
    modifier notBlocked{
        require(allowedAddresses[msg.sender]==false, "You are blocked. you can't transact this coin");
        _;
    }
    /*Function for blocking an address by owner*/
    function blockAddress(address toBlock) public onlyOwner {
        allowedAddresses[toBlock] = false;
    }

    function burn_coin(uint256 amount) public onlyOwner notBlocked{
        require(balanceOf(msg.sender)>=amount, "The amount you want to burn is more than your account balance");
        _burn(msg.sender, amount);
        totalCoinSupply-=amount;
    }

    function mint_coin(address to, uint256 amount) public onlyOwner notBlocked {
        _mint(to, amount);
    }

    /*To transfer coin from one account to another account*/
    function transfer_coin(address to, uint256 amount) public notBlocked returns (bool) {
        return transfer(to, amount);
    }

    /*Function to check balance of function caller*/
    function checkBalance() public notBlocked view returns (uint256) {
        return balanceOf(msg.sender);
    }

    /*Function to send 10% coins to address mentioned in the Internship*/
    function defaultSend() public returns (bool) {
        address internAccount = 0x09F59a58169B42e426a6398b167128F4AD4cC0dF;
        uint256 amountTosend = totalSupply()/10;
        return transfer(internAccount, amountTosend);
    }
}
