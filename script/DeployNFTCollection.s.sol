// SPDX-License-Identifier: MIT
pragma solidity ^0.8.34;

import {Script} from "forge-std/Script.sol";
import {NFTCollection} from "../src/NFTCollection.sol";

contract DeployNFTCollection is Script {

    function run() external returns(NFTCollection) {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        string memory name = "Carabelas de Colon";
        string memory symbol = "3CARAB";
        uint256 totalSupply = 3;
        string memory baseUri = "ipfs://bafybeihieybtize6q5mty5xp4jwai3m43bribubp7onryvvxpnxlroxykq/";

        NFTCollection collection = new NFTCollection(name, symbol, totalSupply, baseUri);
        
        vm.stopBroadcast();
        return collection;
    }
}