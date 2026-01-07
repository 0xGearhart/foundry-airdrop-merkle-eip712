// SPDX-License-Identifier: MIT

import {Deploy} from "../../script/Deploy.s.sol";
import {CodeConstants, HelperConfig} from "../../script/HelperConfig.s.sol";
import {ClaimAirdrop} from "../../script/interactions.s.sol";
import {ClaimAirdropWithUnsplitSignature} from "../../script/interactions.s.sol";
import {AirdropToken} from "../../src/AirdropToken.sol";
import {MerkleAirdrop} from "../../src/MerkleAirdrop.sol";
import {DevOpsTools} from "@devops/DevOpsTools.sol";
import {Test} from "forge-std/Test.sol";

pragma solidity ^0.8.27;

contract InteractionsTest is Test, CodeConstants {
    Deploy deploy;
    MerkleAirdrop merkleAirdrop;
    AirdropToken airdropToken;
    HelperConfig helperConfig;
    HelperConfig.NetworkConfig config;
    ClaimAirdrop claimAirdrop;
    ClaimAirdropWithUnsplitSignature claimAirdropWithUnsplitSignature;

    function testClaimAirdropScriptLocally() public {
        // deploy contracts on selected chain
        helperConfig = new HelperConfig();
        config = helperConfig.getNetworkConfig();
        deploy = new Deploy();
        (airdropToken, merkleAirdrop) = deploy.run();
        claimAirdrop = new ClaimAirdrop();

        // verify initial state
        assertEq(merkleAirdrop.getClaimStatus(config.account), false);
        assertEq(airdropToken.balanceOf(config.account), 0);
        assertEq(airdropToken.balanceOf(address(merkleAirdrop)), INITIAL_SUPPLY);

        // run script
        claimAirdrop.run();

        // verify result
        assertEq(merkleAirdrop.getClaimStatus(config.account), true);
        assertEq(airdropToken.balanceOf(config.account), AIRDROP_CLAIM_AMOUNT);
        assertEq(airdropToken.balanceOf(address(merkleAirdrop)), INITIAL_SUPPLY - AIRDROP_CLAIM_AMOUNT);
    }

    function testClaimAirdropWithUnsplitSignatureScriptLocally() public {
        // deploy contracts on selected chain
        helperConfig = new HelperConfig();
        config = helperConfig.getNetworkConfig();
        deploy = new Deploy();
        (airdropToken, merkleAirdrop) = deploy.run();
        claimAirdropWithUnsplitSignature = new ClaimAirdropWithUnsplitSignature();

        // verify initial state
        assertEq(merkleAirdrop.getClaimStatus(config.account), false);
        assertEq(airdropToken.balanceOf(config.account), 0);
        assertEq(airdropToken.balanceOf(address(merkleAirdrop)), INITIAL_SUPPLY);

        // run script
        claimAirdropWithUnsplitSignature.run();

        // verify result
        assertEq(merkleAirdrop.getClaimStatus(config.account), true);
        assertEq(airdropToken.balanceOf(config.account), AIRDROP_CLAIM_AMOUNT);
        assertEq(airdropToken.balanceOf(address(merkleAirdrop)), INITIAL_SUPPLY - AIRDROP_CLAIM_AMOUNT);
    }

    // when using DevOpsTools.get_most_recent_deployment in scripts, there needs to be a deployed contract on desired blockchain before running forked tests or else no deployment will be found, even when calling deploy in the test itself
    // does not work since testing environment will not correctly use encrypted account keys to sign
    // I think it is because you need to enter keystore password when using encrypted private keys but there is no way to do that outside of the terminal
    // TODO: look into a work around that does not require loading the private key or storing it in plain text
    // function testClaimAirdropScriptOnArbSepoliaFork() public {
    //     // get rpc url from .env
    //     string memory arbSepoliaRpcUrl = vm.envString("ARB_SEPOLIA_RPC_URL");
    //     // create and switch to forked blockchain
    //     vm.createSelectFork(arbSepoliaRpcUrl, 229_828_849); // need to specify block number because this address claimed their airdrop at block 229828850 so need to fork one block prior to claim to test claiming script

    //     // deploy contracts on selected chain
    //     helperConfig = new HelperConfig();
    //     config = helperConfig.getNetworkConfig();
    //     claimAirdrop = new ClaimAirdrop();
    //     airdropToken = AirdropToken(DevOpsTools.get_most_recent_deployment("AirdropToken", block.chainid));
    //     merkleAirdrop = MerkleAirdrop(DevOpsTools.get_most_recent_deployment("MerkleAirdrop", block.chainid));

    //     // verify initial state
    //     assertEq(merkleAirdrop.getClaimStatus(config.account), false);
    //     assertEq(airdropToken.balanceOf(config.account), 0);
    //     assertEq(airdropToken.balanceOf(address(merkleAirdrop)), INITIAL_SUPPLY);

    //     // run script
    //     claimAirdrop.run();

    //     // verify result
    //     assertEq(merkleAirdrop.getClaimStatus(config.account), true);
    //     assertEq(airdropToken.balanceOf(config.account), AIRDROP_CLAIM_AMOUNT);
    //     assertEq(airdropToken.balanceOf(address(merkleAirdrop)), INITIAL_SUPPLY - AIRDROP_CLAIM_AMOUNT);
    // }
}
