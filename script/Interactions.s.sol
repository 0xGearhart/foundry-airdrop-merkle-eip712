// SPDX-License-Identifier: MIT

import {MerkleAirdrop} from "../src/MerkleAirdrop.sol";
import {CodeConstants, HelperConfig} from "./HelperConfig.s.sol";
import {DevOpsTools} from "@devops/DevOpsTools.sol";
import {Script} from "forge-std/Script.sol";

pragma solidity ^0.8.27;

contract ClaimAirdrop is Script, CodeConstants {
    MerkleAirdrop merkleAirdrop;
    HelperConfig helperConfig;
    HelperConfig.NetworkConfig config;
    uint8 v;
    bytes32 r;
    bytes32 s;

    function run() external {
        merkleAirdrop = MerkleAirdrop(DevOpsTools.get_most_recent_deployment("MerkleAirdrop", block.chainid));
        helperConfig = new HelperConfig();
        config = helperConfig.getNetworkConfig();
        // _claimAirdrop();
    }
}
