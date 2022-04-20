pragma solidity ^0.8.0;

import "./verifier.sol";

contract zkHangman {
    Verifier public immutable initVerifier;
    Verifier public immutable guessVerifier;

    uint public constant MAX_INVALID_GUESSES = 6;

    address public host;
    address public player;

    uint public playerLives = MAX_INVALID_GUESSES;
    uint public secretHash;
    uint public correctGuesses;
    uint public turn;

    bool public gameOver;

    uint[26] public guesses;
    uint[5] public characterHashes;
    
    constructor(address _host, address _player, address _initVerifier, address _guessVerifier) {
        host = _host;
        player = _player;
        initVerifier = Verifier(_initVerifier);
        guessVerifier = Verifier(_guessVerifier); 
    } 

    modifier gameNotOver() {
        require(!gameOver, "the game is over!");
        _;
    }

    // verify init proof and set up contract state
    // input[0] contains the hash of the secret
    // input[1..] contains the hashes of the characters
    // the host has to choose a word with a length of 5
    function initializeGame(
            uint[2] memory _a,
            uint[2][2] memory _b,
            uint[2] memory _c,
            uint[6] memory _input
        ) external gameNotOver {
        require(msg.sender == host, "invalid caller");
        require(turn == 0, "invalid turn");
        require(initVerifier.verifyProof(_a, _b, _c, _input), "invalid proof");

        secretHash = input[0];

        for(uint i = 1; i < input.length; i++) {
            characterHashes[i] = input[i];
        }

        turn++;
    }

    function playerGuess(uint _guess) external gameNotOver {
        require(playerLives > 0);
        require(msg.sender == player, "invalid caller");
        require(turn % 2 == 1, "invalid turn");
        require(_guess >= 0 && _guess <= 25, "invalid guess");

        for (uint i = 0; i < (turn - 1) / 2; i++) {
            require(guesses[i] != _guess, "invalid guess");
        }

        guesses[(turn - 1) / 2] = _guess;

        turn++; 
    }

    // input[0] contains the hash of the secret
    // input[1] contains the hash of the character and the secret
    // input[2] contains the character represented as an uint within the range 0-25
    function processGuess(
            uint[2] memory _a,
            uint[2][2] memory _b,
            uint[2] memory _c,
            uint[3] memory _input
        ) external gameNotOver {
        require(msg.sender == host, "invalid caller");
        require(turn != 0 && turn % 2 == 0, "invalid turn");
        require(_input[2] == guesses[turn / 2 - 1], "invalid character");
        require(_input[0] == secretHash, "invalid secret");
        require(guessVerifier.verifyProof(_a, _b, _c, _input), "invalid proof");

        // check if player has made an incorrect guess
        bool incorrectGuess = true;

        for (uint i = 0; i < characterHashes.length; i++) {
            if (_input[1] == characterHashes[i]) {
                incorrectGuess = false;
                correctGuesses++; // this is fine since the player cannot guess the same character twice
            }
        }

        if (incorrectGuess) {
            playerLives -= 1;
        }

        // check if game is over
        if (correctGuesses == characterHashes.length) {
            gameOver = true;
        }

        turn++;
    }
}
