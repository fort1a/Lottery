//SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

contract Lottery {
    address public owner;
    address payable[] public entrants;

    constructor() {
        owner = msg.sender;
    }

    receive() external payable {
        require(msg.value == 0.01 ether);
        entrants.push(payable(msg.sender));
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner");
        _;
    }

    function getBalance() public view onlyOwner returns (uint) {
        return address(this).balance; // balance in wei
    }

    //pseudo random number for study purposes, better to get true random number off chain.
    function random() internal view returns (uint) {
        return
            uint(
                keccak256(
                    abi.encodePacked(
                        block.difficulty,
                        block.timestamp,
                        entrants.length
                    )
                )
            );
    }

    function pickWinner() public onlyOwner {
        require(entrants.length >= 4);

        uint r = random();
        address payable winner;

        uint index = r % entrants.length;

        winner = entrants[index];

        winner.transfer(getBalance());

        entrants = new address payable[](0); // reset after winner is chosen
    }
}
