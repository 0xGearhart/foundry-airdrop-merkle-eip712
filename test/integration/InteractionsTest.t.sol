// SPDX-License-Identifier: MIT

import {Deploy} from "../../script/Deploy.s.sol";
import {CodeConstants, HelperConfig} from "../../script/HelperConfig.s.sol";
import {ClaimAirdrop} from "../../script/interactions.s.sol";
import {AirdropToken} from "../../src/AirdropToken.sol";
import {MerkleAirdrop} from "../../src/MerkleAirdrop.sol";
import {Test} from "forge-std/Test.sol";

pragma solidity ^0.8.27;

contract InteractionsTest is Test, CodeConstants {
    Deploy deploy;
    MerkleAirdrop merkleAirdrop;
    AirdropToken airdropToken;
    HelperConfig helperConfig;
    HelperConfig.NetworkConfig config;
    ClaimAirdrop claimAirdrop;
}
