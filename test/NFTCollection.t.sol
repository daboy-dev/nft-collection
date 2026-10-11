// SPDX-License-Identifier: MIT
pragma solidity ^0.8.34;

import {Test} from "forge-std/Test.sol";
import {IERC721Errors} from "../lib/openzeppelin-contracts/contracts/interfaces/draft-IERC6093.sol";
import {NFTCollection} from "../src/NFTCollection.sol";

contract NFTCollectionTest is Test {
    event MintNFT(address userAddress, uint256 tokenId);

    NFTCollection collection;

    string name = "Carabelas de Colon";
    string symbol = "3CARAB";
    uint256 totalSupply = 3;
    string baseUri = "ipfs://baseuri/";

    address juan = vm.addr(1);
    address luis = vm.addr(2);

    function setUp() public {
        collection = new NFTCollection(name, symbol, totalSupply, baseUri);
    }

    function test_MintAssignsOwnerAndIncrementsId() public {
        vm.prank(juan);
        collection.mint();

        assertEq(collection.ownerOf(0), juan);
        assertEq(collection.balanceOf(juan), 1);
        assertEq(collection.currentTokenId(), 1);

        vm.prank(luis);
        collection.mint();

        assertEq(collection.ownerOf(1), luis);
        assertEq(collection.currentTokenId(), 2);
    }

    function test_MintEmitsEvent() public {
        vm.expectEmit(address(collection));
        emit MintNFT(juan, 0);

        vm.prank(juan);
        collection.mint();
    }

    function test_TokenURI() public {
        vm.prank(juan);
        collection.mint();

        assertEq(collection.tokenURI(0), "ipfs://baseuri/0.json");
    }

    function test_RevertWhen_SoldOut() public {
        for (uint256 i = 0; i < totalSupply; i++) {
            vm.prank(juan);
            collection.mint();
        }

        vm.expectRevert("Sold out!");
        vm.prank(luis);
        collection.mint();
    }

    function test_RevertWhen_TokenURINonexistent() public {
        vm.expectRevert();
        collection.tokenURI(99);
    }
}
