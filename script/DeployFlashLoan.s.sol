// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Script} from "@forge/Script.sol";
import {Helper} from "./Helper.s.sol";
import {FlashLoan} from "../src/FlashLoan.sol";

contract DeployFlashLoan is Script {
    FlashLoan public flashLoan;

    function run() external returns (FlashLoan, Helper) {
        Helper config = new Helper();
        (uint256 deployerKey, , address provider, , )  = config.activeConfig();

        vm.startBroadcast(deployerKey);
        flashLoan = new FlashLoan(provider);
        vm.stopBroadcast();
        
        return (flashLoan, config);
    }
}
