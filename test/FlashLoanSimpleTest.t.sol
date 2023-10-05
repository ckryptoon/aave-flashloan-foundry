// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test} from "@forge/Test.sol";
import {Helper} from "../script/Helper.s.sol";
import {DeployFlashLoanSimple} from "../script/DeployFlashLoanSimple.s.sol";
import {FlashLoanSimple} from "../src/FlashLoanSimple.sol";
import {IERC20} from "@openzeppelin/token/ERC20/IERC20.sol";
import {IERC20Metadata} from "@openzeppelin/token/ERC20/extensions/IERC20Metadata.sol";

contract FlashLoanSimpleTest is Test {
    Helper public config;
    DeployFlashLoanSimple public deployer;
    FlashLoanSimple public flashLoanSimple;

    uint256 public constant START_AMOUNT = 10;
    uint256 public constant BORROW_AMOUNT = 1000;

    bool public constant SUCCESS = true;

    address public owner;
    address public asset;
    uint256 public decimals;
    uint256 public amount;

    function setUp() external {
        deployer = new DeployFlashLoanSimple();
        (flashLoanSimple, config) = deployer.run();
        (, owner, , asset, ) = config.activeConfig();

        decimals = IERC20Metadata(asset).decimals();
        uint256 startAmount = START_AMOUNT * 10 ** decimals;
        amount = BORROW_AMOUNT * 10 ** decimals;

        deal(asset, address(flashLoanSimple), startAmount);
    }

    ////////////////////////////////////////////////////////////////
    // executeOperation                                           //
    ////////////////////////////////////////////////////////////////

    function test_CheckIfAssetAndAmountIsApproved() public {
        uint256 premium = 1 * 10 ** decimals;
        bytes memory params = "";

        bool success = flashLoanSimple.executeOperation(asset, amount, premium, owner, params);
        assertEq(success, SUCCESS);

        assertEq(IERC20(asset).allowance(address(flashLoanSimple), address(flashLoanSimple.POOL())), amount + premium);
    }

    ////////////////////////////////////////////////////////////////
    // requestFlashLoan                                           //
    ////////////////////////////////////////////////////////////////

    function test_RequestFlashLoanSimpleSuccessfully() public {
        vm.prank(owner);
        bool success = flashLoanSimple.requestFlashLoanSimple(asset, amount);
        assertEq(success, SUCCESS);
    }
}
