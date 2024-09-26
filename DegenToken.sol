
// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract DegenToken is ERC20 {

    address public owner;

    constructor() ERC20("Degen", "DGN") {
        owner = msg.sender;
    }

    // Modifier to restrict access to owner only
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    // Event to log token redemptions
    event Redeemed(address indexed account, string itemName, uint256 amount);

    // Mapping to store the required token amount for each item
    mapping(string => uint256) public itemCosts;

    // Mapping to store redeemed items for each address
    mapping(address => string[]) public redeemedItems;

    // Function to set the cost of an item in DegenTokens
    function setItemCost(string memory itemName, uint256 amount) public onlyOwner {
        itemCosts[itemName] = amount;
    }

    // Function to redeem tokens for in-game items
    function redeemToken(string memory itemName) public {
        uint256 cost = itemCosts[itemName];
        require(cost > 0, "Item does not exist");
        require(balanceOf(msg.sender) >= cost, "Insufficient DegenToken balance to redeem this item");

        // Burn the required tokens
        _burn(msg.sender, cost);

        // Record the redeemed item
        redeemedItems[msg.sender].push(itemName);

        // Emit the redemption event
        emit Redeemed(msg.sender, itemName, cost);
    }

    // Function to mint new tokens
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    // Function to burn tokens
    function burn(uint256 amount) public {
        _burn(msg.sender, amount);
    }

    // Function to transfer tokens
    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }
    
    // Function to get redeemed items for a specific address
    function getRedeemedItems(address account) public view returns (string[] memory) {
        return redeemedItems[account];
    }
}
