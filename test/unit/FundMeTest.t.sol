// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import { Test, console } from "forge-std/Test.sol";
import { FundMe } from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;
    address USER = makeAddr("user");
    uint256 constant public TEST_VALUE = 10e18;
    uint256 constant STARTING_BALANCE = 10 ether;
    uint256 constant GAS_PRICE = 1;

    modifier funded() {
        vm.prank(USER);
        fundMe.fund{value: TEST_VALUE}();
        _;
    }

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER,STARTING_BALANCE);
    } 

    function testMinimumDollorIsFive() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testIsownerSameasMsgSender() public{
        assertEq(fundMe.i_owner(), msg.sender);
        // console.log(address(this));
        // console.log(msg.sender);
    }

    function testPriceFeedVersion() public {
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
    }

    function testSendEnoughtEth() public {
        vm.expectRevert();
        fundMe.fund();
    }

    function testPassIfEnoughtEhtSent() public {
        vm.prank(USER);
        fundMe.fund{value: TEST_VALUE}();
        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(amountFunded, TEST_VALUE); 
    }

    function testAddFunderToArrayOfFunders()public {
        vm.prank(USER);
        fundMe.fund{value: TEST_VALUE}();
        address funder = fundMe.getFunder(0);
        assertEq(funder, USER);
    }

    function testOnlyOwner() public funded{
        console.log(msg.sender);
        vm.expectRevert();
        fundMe.withdraw();
        }
    

    

    function testWidthdrawAsSingleOwner() public {
        // Arrange
        uint256 startBalanceOwner = fundMe.getOwner().balance;
        uint256 startingFBalanceundMe = address(fundMe).balance;
        
        // Act
        //uint256 gasStart = gasleft();
        vm.txGasPrice(GAS_PRICE);
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();
        //uint256 gasEnd = gasleft();
        //uint256 gasUsed =(gasStart - gasEnd) * tx.gasprice;
        //console.log("this is gas", gasUsed);

        
        
        //Assert
        uint256 endBalanceOwner = fundMe.getOwner().balance;
        //uint256 endFBalanceundMe = address(fundMe).balance;
        assertEq(startingFBalanceundMe + startBalanceOwner, endBalanceOwner);
        console.log(endBalanceOwner);
        console.log(startBalanceOwner);
    }
     
     function testCheaperwithdrawFromMultipueFunders() funded public{
        // Arrange
        uint160 numberOfFunders = 10;
        console.log(numberOfFunders);
        uint160 startingFunderIndex = 1;
        for(uint160 i = startingFunderIndex; i < numberOfFunders; i++){
            hoax(address(i), TEST_VALUE);
            fundMe.fund{value: TEST_VALUE}();
        }
        uint256 startBalanceOwner = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        // Act
        vm.startPrank(fundMe.getOwner());
        fundMe.cheaperWithdraw();
        vm.stopPrank();
        console.log(startingFundMeBalance);

        //Assert
        assert(address(fundMe).balance == 0);
        assert(startingFundMeBalance + startBalanceOwner == fundMe.getOwner().balance);

     }   
    
    function testwithdrawFromMultipueFunders() funded public{
        // Arrange
        uint160 numberOfFunders = 10;
        console.log(numberOfFunders);
        uint160 startingFunderIndex = 1;
        for(uint160 i = startingFunderIndex; i < numberOfFunders; i++){
            hoax(address(i), TEST_VALUE);
            fundMe.fund{value: TEST_VALUE}();
        }
        uint256 startBalanceOwner = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        // Act
        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank();
        console.log(startingFundMeBalance);

        //Assert
        assert(address(fundMe).balance == 0);
        assert(startingFundMeBalance + startBalanceOwner == fundMe.getOwner().balance);

     }   

   

}
