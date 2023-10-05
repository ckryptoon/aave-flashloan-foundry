# Flashloan with Aave in Foundry

## Introduction

This repository contains all contracts, tests and scripts you need in order to get started with flashloans using the Aave protocol. However, this is only the most basic contracts, tests and scripts, you'll have to introduce your own flashloan logic in these files to make use of it in any way you want. Information on how to test and deploy using this setup is accessible right here in this short documentation.

Always remember to run the following command first in order to load the environment variables, that you'll need to configure yourself in the .env file!

    source .env

## Testing

These tests has been setup in a way, where the Ethereum mainnet is the first network it'll try to run these tests on. You can choose whether you want it to fork the Ethereum mainnet or the Sepolia testnet using the following commands in Foundry.

    forge test --fork-url $MAINNET_RPC_URL
Fork the Ethereum mainnet and run all the tests on it.

    forge test --fork-url $SEPOLIA_RPC_URL
Fork the Sepolia testnet and run all the tests on it.

## Deployment

Scripts has been written for the purpose of deployment, but this is primarily for testnets as your private key is accessible through the .env file. Deployment on the Ethereum mainnet will be done in a different way to increase the protection of your private key, which will also become the private key of the owner of the contracts when deployed. Remember to protect your private keys!

### Using a Script on Sepolia Testnet

    forge script script/DeployFlashLoan.s.sol --rpc-url $SEPOLIA_RPC_URL --etherscan-api-key $ETHERSCAN_API_KEY --verify --broadcast
Broadcast the transaction on the Sepolia testnet, deploy the FlashLoan contract and verify it on Etherscan.
    
    forge script script/DeployFlashLoanSimple.s.sol --rpc-url $SEPOLIA_RPC_URL --etherscan-api-key $ETHERSCAN_API_KEY --verify --broadcast
Broadcast the transaction on the Sepolia testnet, deploy the FlashLoanSimple contract and verify it on Etherscan.

### Using the Create Command on Ethereum Mainnet

Here you need to supply the address of the Aave pool addresses provider <PROVIDER> that exists on the Ethereum mainnet!

    forge create src/FlashLoan.sol:FlashLoan --constructor-args <PROVIDER> --rpc-url $MAINNET_RPC_URL --etherscan-api-key $ETHERSCAN_API_KEY --verify --interactive
Broadcast the transaction on the Ethereum mainnet, deploy the FlashLoan contract and verify it on Etherscan, while providing a better protection for using your private key.

    forge create src/FlashLoanSimple.sol:FlashLoanSimple --constructor-args <PROVIDER> --rpc-url $MAINNET_RPC_URL --etherscan-api-Key $ETHERSCAN_API_KEY --verify --interactive
Broadcast the transaction on the Ethereum mainnet, deploy the FlashLoanSimple contract and verify it on Etherscan, while providing a better protection for using your private key.

## Thanks

Thank you for reading this short documentation, I hope you'll find these contracts, tests and scripts in Foundry useful for creating flashloans in the future! :)
