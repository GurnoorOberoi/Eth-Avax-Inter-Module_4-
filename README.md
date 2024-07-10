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
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract DegenToken is ERC20, Ownable, ERC20Burnable {
    struct Item {
        string name;
        uint8 itemId;
        uint256 price;
    }

    mapping(uint8 => Item) public items;
    uint8 public nextItemId;

    event ItemPurchased(address indexed buyer, uint8 itemId, string itemName, uint256 price);
    event GameOutcome(address indexed player, uint256 randomNumber, bool won, string result);

    constructor(address _initialOwner, uint256 _initialSupply) ERC20("Degen", "DGN") Ownable(_initialOwner) {
        transferOwnership(_initialOwner);
        _mint(_initialOwner, _initialSupply);

        // Initial items
        items[1] = Item("Bronze Badge", 1, 50);
        items[2] = Item("Silver Badge", 2, 150);
        items[3] = Item("Gold Badge", 3, 300);
        items[4] = Item("Platinum Badge", 4, 500);
        items[5] = Item("Diamond Badge", 5, 1000);
        nextItemId = 6;
    }

    function decimals() public pure override returns (uint8) {
        return 0;
    }

    // Minting tokens
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    // Transferring tokens
    function transferToken(address recipient, uint256 amount) external {
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");
        transfer(recipient, amount);
    }

    // Redeeming tokens
    function welcomeBonus() public {
        require(balanceOf(msg.sender) == 0, "Welcome bonus already claimed");
        _mint(msg.sender, 50);
    }

    function addItem(string memory name, uint256 price) public onlyOwner {
        items[nextItemId] = Item(name, nextItemId, price);
        nextItemId++;
    }

     function guessTheNumber(bool prediction, uint256 betAmount) public {
        require(balanceOf(msg.sender) >= betAmount, "Insufficient balance to place bet");

        uint256 randomNumber = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender))) % 10;

        if (prediction == (randomNumber < 5)) {
            _mint(msg.sender, betAmount * 2);
            emit GameOutcome(msg.sender, randomNumber, true, "won");
        } else {
            burn(betAmount);
            emit GameOutcome(msg.sender, randomNumber, false, "lost");
        }
    }

    function purchaseItem(uint8 itemId) external {
        require(items[itemId].price != 0, "Item not found");
        require(balanceOf(msg.sender) >= items[itemId].price, "Insufficient balance");

        burn(items[itemId].price);

        emit ItemPurchased(msg.sender, itemId, items[itemId].name, items[itemId].price);
    }

    // Checking token balance
    function getBalance() external view returns (uint256) {
        return balanceOf(msg.sender);
    }

    // Burning tokens
    function burnToken(uint256 amount) external {
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");
        burn(amount);
    }
}
```

## Author
Name: Gurnoor Oberoi

## License
This project is licensed under the MIT License - see the LICENSE.md file for details

