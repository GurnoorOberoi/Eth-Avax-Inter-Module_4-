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

