// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol"; 
import {DevOpsTools} from "../lib/foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";
//Fund

contract FundFundMe is Script {
    uint256 constant SEND_VALUE = 0.01 ether; 

    function fundFundMe(address mostRecentlyDeployed) public {
        
        FundMe(payable(mostRecentlyDeployed)).fund{value: SEND_VALUE}();
       
    }
    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        vm.startBroadcast();
        fundFundMe(mostRecentlyDeployed);
        vm.stopBroadcast();
    }



}


contract WithdrawFundMe is Script {

    function fundFundMe(address mostRecentlyDeployed) public {
        
        FundMe(payable(mostRecentlyDeployed)).withdraw();
      
    }
    
    function withdrawFundMe(address mostRecentlyDeployed) external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        vm.startBroadcast();
        WithdrawFundMe(mostRecentlyDeployed);
        vm.stopBroadcast();
    }
}

