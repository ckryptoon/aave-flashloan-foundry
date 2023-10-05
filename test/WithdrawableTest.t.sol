// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test} from "@forge/Test.sol";
import {Withdrawable} from "../src/utils/Withdrawable.sol";
import {ERC20} from "@openzeppelin/token/ERC20/ERC20.sol";

contract WithdrawableTest is Test {
    Withdrawable public withdrawable;
    ERC20 public token;

    address public owner = makeAddr("owner");

    address public constant ETH = address(0);
    uint256 public constant AMOUNT = 10 ether;

    event Withdrawn(address indexed recipient, address indexed asset, uint256 amount);

    function setUp() external {
        withdrawable = new Withdrawable();
        token = new ERC20("Test", "TEST");
        
        withdrawable.transferOwnership(owner);
        vm.prank(owner);
        withdrawable.acceptOwnership();
    }

    modifier sendEther() {
        deal(address(this), AMOUNT);
        payable(address(withdrawable)).transfer(AMOUNT);
        _;
    }

    modifier sendToken() {
        deal(address(token), address(withdrawable), AMOUNT);
        _;
    }

    ////////////////////////////////////////////////////////////////
    // ETH                                                        //
    ////////////////////////////////////////////////////////////////

    function test_EthIsEqualToAddressZero() public {
        address eth = withdrawable.ETH();
        assertEq(eth, ETH);
    }

    ////////////////////////////////////////////////////////////////
    // receive                                                    //
    ////////////////////////////////////////////////////////////////

    function test_CanReceiveEther() public sendEther {
        uint256 balance = withdrawable.getBalance(ETH);
        assertEq(balance, AMOUNT);
    }

    ////////////////////////////////////////////////////////////////
    // withdraw                                                   //
    ////////////////////////////////////////////////////////////////

    function test_RevertWhenFailingToWithdrawEther() public sendEther {
        vm.prank(owner);
        withdrawable.transferOwnership(address(this));
        withdrawable.acceptOwnership();
        vm.expectRevert(Withdrawable.Withdrawable__TransferFailed.selector);
        withdrawable.withdraw(ETH, AMOUNT);
    }

    function test_EmitWithdrawnUponWithdrawal() public sendEther {
        vm.expectEmit(true, true, false, true);
        emit Withdrawn(owner, ETH, AMOUNT);
        vm.prank(owner);
        withdrawable.withdraw(ETH, AMOUNT);
    }

    function test_CanWithdrawEther() public sendEther {
        uint256 finalBalance = 0;
        vm.prank(owner);
        withdrawable.withdraw(ETH, AMOUNT);
        uint256 balance = withdrawable.getBalance(ETH);
        assertEq(balance, finalBalance);
    }

    function test_CanWithdrawToken() public sendToken {
        uint256 finalBalance = 0;
        vm.prank(owner);
        withdrawable.withdraw(address(token), AMOUNT);
        uint256 balance = token.balanceOf(address(withdrawable));
        assertEq(balance, finalBalance);
    }

    ////////////////////////////////////////////////////////////////
    // getBalance                                                 //
    ////////////////////////////////////////////////////////////////

    function test_CanGetEtherBalance() public sendEther {
        uint256 balance = withdrawable.getBalance(ETH);
        assertEq(balance, AMOUNT);
    }

    function test_CanGetTokenBalance() public sendToken {
        uint256 balance = withdrawable.getBalance(address(token));
        assertEq(balance, AMOUNT);
    }
}
