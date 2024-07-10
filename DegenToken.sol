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
