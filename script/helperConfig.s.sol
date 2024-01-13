// SPDX-License-Identifier: MIT
 //1. Deploy mock when were on local Anvil chain.
//2. keep track of contract addresses across differant chains.
//sepolia ETH/USD
//MainNet ETH/USD etc 

pragma solidity ^0.8.19;
// If on local Anvil we deploy mocks
// Otherwise get the existing address from the live networks 
import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    
    NetworkConfig public activeNetworkConfig;
    
    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000e8;
    struct NetworkConfig {
        address priceFeed; // Eth/USD  if the struct  
        }
    
    constructor() {
        if (block.chainid == 11155111){
            activeNetworkConfig = getSepoliaEthConfig();
        }
        else{
            activeNetworkConfig = getAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns(NetworkConfig memory){
        // priceFeedAdress
        NetworkConfig memory sepoliaConfig = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });

        return sepoliaConfig;
    }

    function getAnvilEthConfig() public returns(NetworkConfig memory){
        if (activeNetworkConfig.priceFeed != address(0)){
            return activeNetworkConfig;
        }
        // 1. deploy the mocks.
        // 2. Return the mocks address.
        vm.startBroadcast();
        MockV3Aggregator MockPriceFeed = new MockV3Aggregator(DECIMALS, INITIAL_PRICE);
        vm.stopBroadcast();
        NetworkConfig memory anvilConfig = NetworkConfig({
            priceFeed: address(MockPriceFeed)
        });
        return anvilConfig; 
    }
}