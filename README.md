# Degen Token Smart Contract

The DegenToken smart contract is an ERC20-compliant token implementation designed to support a decentralized gaming platform. Built using the OpenZeppelin library, this token is named "Degen" with the symbol "DGN". The contract includes additional functionalities for minting, burning, transferring tokens, and special features tailored for gaming such as redeeming tokens for in-game items and a betting mechanism. The primary goal is to enhance user experience and interaction within the gaming ecosystem by integrating these functionalities.

### Features
#### 1. Minting New Tokens
The platform owner has the exclusive ability to mint new tokens. This function allows the controlled issuance of tokens, which can be distributed as rewards or incentives to players.

#### 2. Transferring Tokens
Players can transfer their tokens to others using standard ERC20 transfer functionality. This feature ensures secure and efficient transactions within the gaming platform.

#### 3. Redeeming Tokens
Players can redeem their tokens for various items available in the in-game store. The contract owner can add new items to the store, each with a specified price.

#### 4. Checking Token Balance
Players can check their token balance at any time to keep track of their holdings.

#### 5. Burning Tokens
Any token holder can burn tokens they own, effectively reducing the total supply. This helps manage token inflation and allows users to remove unused tokens from circulation.

#### 6. Welcome Bonus
New users receive a welcome bonus of tokens upon their first interaction with the contract.

#### 7. Betting Mechanism
The contract includes a simple betting game where users can predict a random number. Winners receive double their bet amount, while losers have their bet amount burned.

## Get Started
### Executing Program 
To run this program, you can use Remix, an online Solidity IDE. To get started, go to the Remix website at Remix Ethereum.


``` Solidity

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

```

## Author
Name: Gurnoor Oberoi

## License
This project is licensed under the MIT License - see the LICENSE.md file for details

