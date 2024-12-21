// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FantasyStrategyGame {
    struct Player {
        address addr;
        string name;
        string role; // Wizard, Knight, Scholar, etc.
        uint256 level;
        uint256 points;
    }

    struct Challenge {
        uint256 id;
        string description;
        uint256 rewardPoints;
        bool solved;
    }

    mapping(address => Player) public players;
    Challenge[] public challenges;

    event PlayerRegistered(address indexed player, string name, string role);
    event ChallengeSolved(address indexed player, uint256 challengeId, uint256 rewardPoints);
    event LevelUp(address indexed player, uint256 newLevel);

    modifier onlyRegistered() {
        require(bytes(players[msg.sender].name).length > 0, "Player not registered");
        _;
    }

    constructor() {
        // Initialize challenges
        challenges.push(Challenge(1, "Solve a math puzzle: What is 2+2?", 10, false));
        challenges.push(Challenge(2, "History trivia: When did the French Revolution start?", 20, false));
        challenges.push(Challenge(3, "Science riddle: What is H2O?", 15, false));
    }

    function registerPlayer(string memory _name, string memory _role) public {
        require(bytes(players[msg.sender].name).length == 0, "Player already registered");

        players[msg.sender] = Player({
            addr: msg.sender,
            name: _name,
            role: _role,
            level: 1,
            points: 0
        });

        emit PlayerRegistered(msg.sender, _name, _role);
    }

    function solveChallenge(uint256 _challengeId) public onlyRegistered {
        require(_challengeId < challenges.length, "Invalid challenge ID");
        Challenge storage challenge = challenges[_challengeId];

        require(!challenge.solved, "Challenge already solved");

        Player storage player = players[msg.sender];

        // Mark the challenge as solved and reward points
        challenge.solved = true;
        player.points += challenge.rewardPoints;

        // Level up the player if they reach a points threshold
        if (player.points >= 50 && player.level < 2) {
            player.level = 2;
            emit LevelUp(msg.sender, player.level);
        } else if (player.points >= 100 && player.level < 3) {
            player.level = 3;
            emit LevelUp(msg.sender, player.level);
        }

        emit ChallengeSolved(msg.sender, _challengeId, challenge.rewardPoints);
    }

    function getPlayer(address _player) public view returns (Player memory) {
        return players[_player];
    }

    function getChallenges() public view returns (Challenge[] memory) {
        return challenges;
    }
}
