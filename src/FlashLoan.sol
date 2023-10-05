// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Withdrawable} from "./utils/Withdrawable.sol";
import {FlashLoanReceiverBase} from "@aave/flashloan/base/FlashLoanReceiverBase.sol";
import {IPoolAddressesProvider} from "@aave/interfaces/IPoolAddressesProvider.sol";
import {IERC20} from "@openzeppelin/token/ERC20/IERC20.sol";

/**
 * @title FlashLoan
 * @author Casper Kjær Rasmussen / @ckryptoon
 * @notice This is an example contract for Aave (v3) FlashLoan.
 */
contract FlashLoan is Withdrawable, FlashLoanReceiverBase {
    error FlashLoan__InvalidAssetsOrAmountsOrPremiumsLength();
    error FlashLoan__InvalidAssetsOrAmountsLength();

    /**
     * @notice This is the contructor for a contract that's able to make and receive a flashloan on Aave.
     * @param _provider The address of the Aave pool addresses provider.
     */
    constructor(address _provider) FlashLoanReceiverBase(IPoolAddressesProvider(_provider)) {}

    /**
     * @notice This function is needed by the Aave protocol to approve assets and amounts plus premiums in order for the flashloan to go through.
     * @dev This is where you implement your own flashloan logic.
     * @param _assets The assets to be approved.
     * @param _amounts The amounts of the assets to be approved.
     * @param _premiums The premiums is the fee you need to pay for each asset borrowed.
     * @param _initiator This is an unused variable in this contract.
     * @param _params This is an unused variable in this contract.
     */
    function executeOperation(
        address[] calldata _assets,
        uint256[] calldata _amounts,
        uint256[] calldata _premiums,
        address _initiator,
        bytes calldata _params
    )
        external
        override
        returns (bool)
    {
        _initiator;
        _params;

        if (_assets.length != _amounts.length || _amounts.length != _premiums.length) revert FlashLoan__InvalidAssetsOrAmountsOrPremiumsLength();
        
        //
        // INSERT YOUR OWN FLASHLOAN LOGIC HERE!
        //

        for (uint256 i = 0; i < _assets.length; i++) {
            uint256 amount = _amounts[i] + _premiums[i];
            IERC20(_assets[i]).approve(address(POOL), amount);
        }
        
        return true;
    }

    /**
     * @notice This function will request the flashloan.
     * @param _assets The assets to borrow.
     * @param _amounts The amounts of the assets to borrow.
     */
    function requestFlashLoan(address[] calldata _assets, uint256[] calldata _amounts) external onlyOwner returns (bool) {
        if (_assets.length != _amounts.length) revert FlashLoan__InvalidAssetsOrAmountsLength();

        address receiver = address(this);
        address onBehalfOf = address(this);
        bytes memory params = "";
        uint16 referralCode = 0;

        uint256[] memory modes = new uint256[](_assets.length);

        for (uint256 i = 0; i < _assets.length; i++) {
            modes[i] = 0;
        }

        POOL.flashLoan(receiver, _assets, _amounts, modes, onBehalfOf, params, referralCode);

        return true;
    }
}
