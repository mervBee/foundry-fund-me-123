// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol"; 
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./helperConfig.s.sol";

contract DeployFundMe is Script{

    function run() external returns(FundMe){
        HelperConfig helperConfig = new HelperConfig(); 
        address ethUsdPriceFeed = helperConfig.activeNetworkConfig(); //if the networkConfig struct publicly known as 
        vm.startBroadcast();                                          //activeNetworkConfig  had more than 1 entry then                           
        FundMe fundMe = new FundMe(ethUsdPriceFeed);                             //then variable would be like(address ethausd, ,,,,) etc
        vm.stopBroadcast();

        return fundMe;
    }
}