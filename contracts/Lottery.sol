// Raffle
// Enter the lottery(paying some amount)
// Pick a random winner (verifiably random)
// Winner to be selected every X minutes -> completely automated
// Chainlink Oracle -> Randomness, Automated Execution (Chainlink Keepers)

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";

error Raffle__NotEnoughEthEntered();

contract Raffle is VRFConsumerBaseV2 {
    /* State Variables */
    uint256 private immutable i_entranceFee;
    address payable[] private s_players;
    VRFCoordinatorV2Interface private immutable i_vrfCoordinator;
    bytes32 private immutable i_gasLane;

    /* Events */
    event RaffleEnter(address indexed player);

    constructor(
        address vrfCoordinatorV2,
        uint256 entranceFee,
        bytes32 gasLane
    ) VRFConsumerBaseV2(vrfCoordinatorV2) {
        i_entranceFee = entranceFee;
        i_vrfCoordinator = VRFCoordinatorV2Interface(vrfCoordinatorV2);
        i_gasLane = gasLane;
    }

    function enterRaffle() public payable {
        //require(msg.value == i_entranceFee, "You must pay the entrance fee to enter the raffle");
        if (msg.value < i_entranceFee) {
            revert Raffle__NotEnoughEthEntered();
        }
        s_players.push(payable(msg.sender));
        //Emit an event when we update a dynamic array or mapping
        //Named events with the function name reversed
        emit RaffleEnter(msg.sender);
    }

    function requestRandomWinner() external {
        //request a random number
        //use the random number
        //2 transaction process
        i_vrfCoordinator.requestRandomWords(
            i_gasLane,
            s_subscriptionId,
            requestConfirmations,
            callbackGasLimit,
            numWords
        );
    }

    function fulfillRandomWords(
        uint256 requestId,
        uint256[] memory randomWords
    ) internal override {}

    /* View / Pure functions */
    function getEntranceFee() public view returns (uint256) {
        return i_entranceFee;
    }

    function getplayer(uint256 index) public view returns (address payable) {
        return s_players[index];
    }
}
