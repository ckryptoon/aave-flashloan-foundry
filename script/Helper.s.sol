// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Script} from "@forge/Script.sol";

contract Helper is Script {
    struct Config {
        uint256 deployerKey;
        address owner;
        address provider;
        address weth;
        address dai;
    }

    Config public activeConfig;

    uint256 public privateKey = vm.envUint("DEPLOYER_KEY");

    constructor() {
        if (block.chainid == 1) {
            activeConfig = getEthMainnetConfig();
        } else {
            activeConfig = getEthSepoliaConfig();
        }
    }

    function getEthMainnetConfig() public view returns (Config memory) {
        return Config({
            deployerKey: privateKey,
            owner: vm.addr(privateKey),
            provider: 0x2f39d218133AFaB8F2B819B1066c7E434Ad94E9e,
            weth: 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2,
            dai: 0x6B175474E89094C44Da98b954EedeAC495271d0F
        });
    }

    function getEthSepoliaConfig() public view returns (Config memory) {
        return Config({
            deployerKey: privateKey,
            owner: vm.addr(privateKey),
            provider: 0x012bAC54348C0E635dCAc9D5FB99f06F24136C9A,
            weth: 0xC558DBdd856501FCd9aaF1E62eae57A9F0629a3c,
            dai: 0xFF34B3d4Aee8ddCd6F9AFFFB6Fe49bD371b8a357
        });
    }
}
