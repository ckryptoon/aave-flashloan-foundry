// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Script} from "@forge/Script.sol";
import {Helper} from "./Helper.s.sol";
import {FlashLoanSimple} from "../src/FlashLoanSimple.sol";

contract DeployFlashLoanSimple is Script {
    FlashLoanSimple public flashLoanSimple;

    function run() external returns (FlashLoanSimple, Helper) {
        Helper config = new Helper();
        (uint256 deployerKey, , address provider, , ) = config.activeConfig();

        vm.startBroadcast(deployerKey);
        flashLoanSimple = new FlashLoanSimple(provider);
        vm.stopBroadcast();
        
        return (flashLoanSimple, config);
    }
}
