# NOTHING-token #
This repository includes the smart contract of Nothing-token

### How do I get set up? ###
1. https://github.com/Saifdevblochain/Nothing-Token.git
2. cd Nothing-Token
3. npm i 

### Deployment to a testnet or mainnet ###
1. Setup environment variables

You'll want to set your URL,API_KEY and PRIVATE_KEY/PRIVATE_KEY_MAIN as environment variables. You can add them to a .env file, similar to what you see in .env.example.<br> <br>
PRIVATE_KEY/PRIVATE_KEY_MAIN: The private key of your account (like from metamask). NOTE: FOR DEVELOPMENT, PLEASE USE A KEY THAT DOESN'T HAVE ANY REAL FUNDS ASSOCIATED WITH IT.<br> <br>
URL: This is url of the Goerli testnet node you're working with. You can get setup with one for free from Alchemy<br> <br>
API_KEY: This is etherscan api key used for verification of contracts<br> 

2. Get testnet ETH

3. npx hardhat run ./scripts/deploy.js --network goerli

