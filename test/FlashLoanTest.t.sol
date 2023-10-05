// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test} from "@forge/Test.sol";
import {Helper} from "../script/Helper.s.sol";
import {DeployFlashLoan} from "../script/DeployFlashLoan.s.sol";
import {FlashLoan} from "../src/FlashLoan.sol";
import {IERC20} from "@openzeppelin/token/ERC20/IERC20.sol";
import {IERC20Metadata} from "@openzeppelin/token/ERC20/extensions/IERC20Metadata.sol";

contract FlashLoanTest is Test {
    DeployFlashLoan public deployer;
    FlashLoan public flashLoan;

    uint256 public constant START_AMOUNT = 10;
    uint256 public constant BORROW_AMOUNT = 1000;

    bool public constant SUCCESS = true;
    bytes public constant PARAMS = "";

    address public owner;
    address[] public assets;
    uint256[] public decimals;
    uint256[] public amounts;

    function setUp() external {
        Helper config = new Helper();
        deployer = new DeployFlashLoan();
        (flashLoan, config) = deployer.run();
        (, owner, , , ) = config.activeConfig();
        (, , , address weth, address dai) = config.activeConfig();

        assets.push(weth);
        assets.push(dai);

        uint256[] memory startAmounts = new uint256[](assets.length);

        for (uint256 i = 0; i < assets.length; i++) {
            decimals.push(IERC20Metadata(assets[i]).decimals());
            startAmounts[i] = START_AMOUNT * 10 ** decimals[i];
            amounts.push(BORROW_AMOUNT * 10 ** decimals[i]);
            deal(assets[i], address(flashLoan), startAmounts[i]);
        }
    }

    ////////////////////////////////////////////////////////////////
    // executeOperation                                           //
    ////////////////////////////////////////////////////////////////

    function test_RevertIfInvalidAssetsOrAmountsOrPremiumsLength() public {
        uint256[] memory premiums = new uint256[](assets.length + 1);
        vm.expectRevert(FlashLoan.FlashLoan__InvalidAssetsOrAmountsOrPremiumsLength.selector);
        flashLoan.executeOperation(assets, amounts, premiums, owner, PARAMS);
    }

    function test_CheckIfCorrectAssetsAndAmountsAreApproved() public {
        uint256[] memory premiums = new uint256[](assets.length);

        for (uint256 i = 0; i < assets.length; i++) {
            premiums[i] = 1 * 10 ** decimals[i];
        }

        bool success = flashLoan.executeOperation(assets, amounts, premiums, owner, PARAMS);
        assertEq(success, SUCCESS);

        for (uint256 i = 0; i < assets.length; i++) {
            assertEq(IERC20(assets[i]).allowance(address(flashLoan), address(flashLoan.POOL())), amounts[i] + premiums[i]);
        }
    }

    ////////////////////////////////////////////////////////////////
    // requestFlashLoan                                           //
    ////////////////////////////////////////////////////////////////

    function test_RevertIfInvalidAssetsOrAmountsLength() public {
        assets.push(address(0));
        vm.expectRevert(FlashLoan.FlashLoan__InvalidAssetsOrAmountsLength.selector);
        vm.prank(owner);
        flashLoan.requestFlashLoan(assets, amounts);
    }

    function test_RequestFlashLoanSuccessfully() public {
        vm.prank(owner);
        bool success = flashLoan.requestFlashLoan(assets, amounts);
        assertEq(success, SUCCESS);
    }
}
