// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/RayTaiNFT.sol";

contract RayTaiNFT_Test is Test {
    RayTaiNFT nft;
    address constant AL_ADDRESS = 0x1904166894a3b50764F165175599AEDD3C9c29Ce;
    address constant NOT_AL_ADDRESS = 0x1904166894a3B50764f165175599AEdd3c9c29CF;

    function setUp() public {
        nft = new RayTaiNFT("RayTai", "RATA", bytes32(0xdc7a451e18cea32d0f7d9b19afb264ad3effd8e2a837d1077be037390471f979),
            25000000 gwei, 33000000 gwei,
            2, 3,
            5,
            17250000
        );
    }

    function testBuyingOneFromALduringAL() public {
        uint256 amountOfNFTs = nft.balanceOf(AL_ADDRESS);
        assertEq(amountOfNFTs, 0);

        bytes32[] memory proof = new bytes32[](2);
        proof[0] = bytes32(0x46f9c5c89fb1dcb5e9700e66c106df9c6032f4f8d4c028e8fdc72edaa21b2872);
        proof[1] = bytes32(0x233484032c7c27e1b364617283af5a5964d91576a985e46c14ea9e10e69edf23);
        hoax(AL_ADDRESS, 1 ether);
        nft.mint{value: 25000000 gwei}(AL_ADDRESS, uint8(1), proof);

        amountOfNFTs = nft.balanceOf(AL_ADDRESS);
        assertEq(amountOfNFTs, 1);
    }

    function testBuyingTwoFromALduringAL() public {
        uint256 amountOfNFTs = nft.balanceOf(AL_ADDRESS);
        assertEq(amountOfNFTs, 0);

        bytes32[] memory proof = new bytes32[](2);
        proof[0] = bytes32(0x46f9c5c89fb1dcb5e9700e66c106df9c6032f4f8d4c028e8fdc72edaa21b2872);
        proof[1] = bytes32(0x233484032c7c27e1b364617283af5a5964d91576a985e46c14ea9e10e69edf23);
        hoax(AL_ADDRESS, 1 ether);
        nft.mint{value: 50000000 gwei}(AL_ADDRESS, uint8(2), proof);

        amountOfNFTs = nft.balanceOf(AL_ADDRESS);
        assertEq(amountOfNFTs, 2);
    }

    function testFailBuyingFromALduringALMoreThanAllowed() public {
        uint256 amountOfNFTs = nft.balanceOf(AL_ADDRESS);
        assertEq(amountOfNFTs, 0);

        bytes32[] memory proof = new bytes32[](2);
        proof[0] = bytes32(0x46f9c5c89fb1dcb5e9700e66c106df9c6032f4f8d4c028e8fdc72edaa21b2872);
        proof[1] = bytes32(0x233484032c7c27e1b364617283af5a5964d91576a985e46c14ea9e10e69edf23);
        hoax(AL_ADDRESS, 1 ether);
        nft.mint{value: 75000000 gwei}(AL_ADDRESS, uint8(3), proof);
    }

    function testFailBuyingFromALduringALWrongAmountOfFunds() public {
        bytes32[] memory proof = new bytes32[](2);
        proof[0] = bytes32(0x46f9c5c89fb1dcb5e9700e66c106df9c6032f4f8d4c028e8fdc72edaa21b2872);
        proof[1] = bytes32(0x233484032c7c27e1b364617283af5a5964d91576a985e46c14ea9e10e69edf23);
        hoax(AL_ADDRESS, 1 ether);
        nft.mint{value: 24999999 gwei}(AL_ADDRESS, uint8(1), proof);
    }

    function testBuyingMoreThanTotalGivesYouAReturn() public {
        vm.deal(AL_ADDRESS, 1 ether);
        uint256 amountOfNFTs = nft.balanceOf(AL_ADDRESS);
        assertEq(amountOfNFTs, 0);

        bytes32[] memory proof = new bytes32[](2);
        proof[0] = bytes32(0x46f9c5c89fb1dcb5e9700e66c106df9c6032f4f8d4c028e8fdc72edaa21b2872);
        proof[1] = bytes32(0x233484032c7c27e1b364617283af5a5964d91576a985e46c14ea9e10e69edf23);
        vm.startPrank(AL_ADDRESS);
        nft.mint{value: 50000000 gwei}(AL_ADDRESS, uint8(2), proof);
        vm.stopPrank();
        amountOfNFTs = nft.balanceOf(AL_ADDRESS);
        assertEq(amountOfNFTs, 2);

        address another_al = 0x1904166894A3B50764F165175599AeDD3c9c29cD;
        vm.deal(another_al, 1 ether);
        proof[0] = bytes32(0x6b9d45d25b0453dc96a2418fdfecefaa0f56580aafe6fe7257953ba977ed9604);
        proof[1] = bytes32(0x233484032c7c27e1b364617283af5a5964d91576a985e46c14ea9e10e69edf23);
        vm.startPrank(another_al);
        nft.mint{value: 50000000 gwei}(another_al, uint8(2), proof);
        vm.stopPrank();
        amountOfNFTs = nft.balanceOf(another_al);
        assertEq(amountOfNFTs, 2);

        another_al = 0x1904166894A3b50764F165175599aedd3c9C29Cc;
        vm.deal(another_al, 1 ether);
        uint256 preMintBalance = another_al.balance;
        proof = new bytes32[](1);
        proof[0] = bytes32(0x5295bd75d36cdd01e8d81270f26cc44d925374f343b30977eb5d7b1c53905300);
        vm.startPrank(another_al);
        nft.mint{value: 50000000 gwei}(another_al, uint8(2), proof);
        vm.stopPrank();
        amountOfNFTs = nft.balanceOf(another_al);
        uint256 postMintBalance = another_al.balance;
        assertApproxEqAbs(preMintBalance, 25000000 gwei + postMintBalance, 0);
        assertEq(amountOfNFTs, 1);
    }

    function testFailWrongMerkleProof() public {
        uint256 amountOfNFTs = nft.balanceOf(AL_ADDRESS);
        assertEq(amountOfNFTs, 0);

        bytes32[] memory proof = new bytes32[](2);
        proof[0] = bytes32(0x36f9c5c89fb1dcb5e9700e66c106df9c6032f4f8d4c028e8fdc72edaa21b2872);
        proof[1] = bytes32(0x233484032c7c27e1b364617283af5a5964d91576a985e46c14ea9e10e69edf23);
        hoax(AL_ADDRESS, 1 ether);
        nft.mint{value: 25000000 gwei}(AL_ADDRESS, uint8(1), proof);
    }

    function testFailBuyingFromNotALduringAL() public {
        hoax(NOT_AL_ADDRESS, 1 ether);
        nft.mint{value: 33000000 gwei}(AL_ADDRESS, uint8(1));
    }

    function testBuyingOneFromALduringPS() public {
        /* AL discount is not valid */
        vm.roll(17250000);
        uint256 amountOfNFTs = nft.balanceOf(AL_ADDRESS);
        assertEq(amountOfNFTs, 0);

        bytes32[] memory proof = new bytes32[](2);
        proof[0] = bytes32(0x46f9c5c89fb1dcb5e9700e66c106df9c6032f4f8d4c028e8fdc72edaa21b2872);
        proof[1] = bytes32(0x233484032c7c27e1b364617283af5a5964d91576a985e46c14ea9e10e69edf23);
        hoax(AL_ADDRESS, 1 ether);
        nft.mint{value: 33000000 gwei}(AL_ADDRESS, uint8(1), proof);

        amountOfNFTs = nft.balanceOf(AL_ADDRESS);
        assertEq(amountOfNFTs, 1);
    }

    function testBuyingThreeFromNonALdurincPS() public {
        vm.roll(17250000);
        uint256 amountOfNFTs = nft.balanceOf(NOT_AL_ADDRESS);
        assertEq(amountOfNFTs, 0);

        hoax(NOT_AL_ADDRESS, 1 ether);
        nft.mint{value: 99000000 gwei}(NOT_AL_ADDRESS, uint8(3));

        amountOfNFTs = nft.balanceOf(NOT_AL_ADDRESS);
        assertEq(amountOfNFTs, 3);
    }

    function testBuyingFiveFromAL() public {
        uint256 amountOfNFTs = nft.balanceOf(AL_ADDRESS);
        assertEq(amountOfNFTs, 0);

        bytes32[] memory proof = new bytes32[](2);
        proof[0] = bytes32(0x46f9c5c89fb1dcb5e9700e66c106df9c6032f4f8d4c028e8fdc72edaa21b2872);
        proof[1] = bytes32(0x233484032c7c27e1b364617283af5a5964d91576a985e46c14ea9e10e69edf23);
        hoax(AL_ADDRESS, 1 ether);
        nft.mint{value: 50000000 gwei}(AL_ADDRESS, uint8(2), proof);

        amountOfNFTs = nft.balanceOf(AL_ADDRESS);
        assertEq(amountOfNFTs, 2);

        vm.roll(17250000);
        hoax(NOT_AL_ADDRESS, 1 ether);
        nft.mint{value: 33000000 gwei}(NOT_AL_ADDRESS, uint8(1));

        hoax(AL_ADDRESS, 1 ether);
        nft.mint{value: 99000000 gwei}(AL_ADDRESS, uint8(3));

        amountOfNFTs = nft.balanceOf(AL_ADDRESS);
        assertEq(amountOfNFTs, 4);
    }

    function testBuyingFourFromAL() public {
        // AL-ed walled tries to buy 5, but gets 4 because of a limit.
        uint256 amountOfNFTs = nft.balanceOf(AL_ADDRESS);
        assertEq(amountOfNFTs, 0);

        bytes32[] memory proof = new bytes32[](2);
        proof[0] = bytes32(0x46f9c5c89fb1dcb5e9700e66c106df9c6032f4f8d4c028e8fdc72edaa21b2872);
        proof[1] = bytes32(0x233484032c7c27e1b364617283af5a5964d91576a985e46c14ea9e10e69edf23);
        hoax(AL_ADDRESS, 1 ether);
        nft.mint{value: 50000000 gwei}(AL_ADDRESS, uint8(2), proof);

        amountOfNFTs = nft.balanceOf(AL_ADDRESS);
        assertEq(amountOfNFTs, 2);

        vm.roll(17250000);

        hoax(AL_ADDRESS, 1 ether);
        nft.mint{value: 99000000 gwei}(AL_ADDRESS, uint8(3));

        amountOfNFTs = nft.balanceOf(AL_ADDRESS);
        assertEq(amountOfNFTs, 5);
    }

    function testSettingURL() public {
        vm.roll(17250000);
        hoax(AL_ADDRESS, 1 ether);
        nft.mint{value: 99000000 gwei}(AL_ADDRESS, uint8(3));

        nft.setBaseURL("http://www.example.com/#");
        assertEq(nft.tokenURI(0), "http://www.example.com/#0.json");
        assertEq(nft.tokenURI(1), "http://www.example.com/#1.json");
        assertEq(nft.tokenURI(2), "http://www.example.com/#2.json");

        nft.setBaseURL("http://www.example.com/");
        assertEq(nft.tokenURI(0), "http://www.example.com/0.json");
        assertEq(nft.tokenURI(1), "http://www.example.com/1.json");
        assertEq(nft.tokenURI(2), "http://www.example.com/2.json");
    }

    function testFailSettingURLFromWrongAddress() public {
        vm.roll(17250000);
        hoax(AL_ADDRESS, 1 ether);
        nft.mint{value: 99000000 gwei}(AL_ADDRESS, uint8(3));
        hoax(AL_ADDRESS, 1 ether);
        nft.setBaseURL("http://www.example.com/#");
    }
}


/*
contract CounterTest is Test {
    Counter public counter;

    function setUp() public {
        counter = new Counter();
        counter.setNumber(0);
    }

    function testIncrement() public {
        counter.increment();
        assertEq(counter.number(), 1);
    }

    function testSetNumber(uint256 x) public {
        counter.setNumber(x);
        assertEq(counter.number(), x);
    }
}
*/