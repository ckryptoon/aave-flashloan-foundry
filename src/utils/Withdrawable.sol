// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Ownable2Step} from "@openzeppelin/access/Ownable2Step.sol";
import {IERC20} from "@openzeppelin/token/ERC20/IERC20.sol";

/**
 * @title Withdrawable
 * @author Casper Kjær Rasmussen / @ckryptoon
 * @notice This contract provides a way to receive and withdraw ETH and ERC20 tokens from it.
 */
contract Withdrawable is Ownable2Step {
    error Withdrawable__TransferFailed();

    address public constant ETH = address(0);

    event Withdrawn(address indexed recipient, address indexed asset, uint256 amount);

    receive() external payable {}

    /**
     * @notice This function makes it possible to withdraw both ETH and ERC20 tokens from this contract.
     * @param _asset The asset to be withdrawn.
     * @param _amount The amount of the asset to be withdrawn.
     */
    function withdraw(address _asset, uint256 _amount) external onlyOwner {
        if (_asset == ETH) {
            (bool success, ) = payable(owner()).call{value: _amount, gas: 2300}("");
            if (!success) revert Withdrawable__TransferFailed();
        } else {
            IERC20(_asset).transfer(owner(), _amount);
        }

        emit Withdrawn(owner(), _asset, _amount);
    }

    /**
     * @notice This function helps you get the balance of both ETH and ERC20 tokens in this contract.
     * @param _asset The asset you need to check the balance of.
     */
    function getBalance(address _asset) external view returns (uint256) {
        if (_asset == ETH) {
            return address(this).balance;
        }
        return IERC20(_asset).balanceOf(address(this));
    }
}
