// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Withdrawable} from "./utils/Withdrawable.sol";
import {FlashLoanSimpleReceiverBase} from "@aave/flashloan/base/FlashLoanSimpleReceiverBase.sol";
import {IPoolAddressesProvider} from "@aave/interfaces/IPoolAddressesProvider.sol";
import {IERC20} from "@openzeppelin/token/ERC20/IERC20.sol";

/**
 * @title FlashLoanSimple
 * @author Casper Kjær Rasmussen / @ckryptoon
 * @notice This is an example contract for Aave (v3) FlashLoanSimple.
 */
contract FlashLoanSimple is Withdrawable, FlashLoanSimpleReceiverBase {

    /**
     * @notice This is the contructor for a contract that's able to make and receive a flashloan on Aave.
     * @param _provider The address of the Aave pool addresses provider.
     */
    constructor(address _provider) FlashLoanSimpleReceiverBase(IPoolAddressesProvider(_provider)) {}

    /**
     * @notice This function is needed by the Aave protocol to approve asset and amount plus premium in order for the flashloan to go through.
     * @dev This is where you implement your own flashloan logic.
     * @param _asset The asset to be approved.
     * @param _amount The amount of the asset to be approved.
     * @param _premium The premium is the fee you need to pay for each asset borrowed.
     * @param _initiator This is an unused variable in this contract.
     * @param _params This is an unused variable in this contract.
     */
    function executeOperation(
        address _asset,
        uint256 _amount,
        uint256 _premium,
        address _initiator,
        bytes calldata _params
    ) external override returns (bool) {
        _initiator;
        _params;

        //
        // INSERT YOUR OWN FLASHLOAN LOGIC HERE!
        //

        uint256 amount = _amount + _premium;
        IERC20(_asset).approve(address(POOL), amount);

        return true;
    }

    /**
     * @notice This function will request the flashloan.
     * @param _asset The asset to borrow.
     * @param _amount The amount of the asset to borrow.
     */
    function requestFlashLoanSimple(address _asset, uint256 _amount) external onlyOwner returns (bool) {
        address receiver = address(this);
        bytes memory params = "";
        uint16 referralCode = 0;

        POOL.flashLoanSimple(receiver, _asset, _amount, params, referralCode);

        return true;
    }
}
