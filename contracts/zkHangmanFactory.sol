pragma solidity ^0.8.0;

import './zkHangman.sol';

contract zkHangmanFactory {
    address[] public games;

    event GameCreated(address indexed host, address indexed player, adress initVerifier, address guessVerifier);

    function createGame(address _host, address _player, address _initVerifier, address _guessVerifier) {
        zkHangman game = new zkHangman(_host, _player, _initVerifier, _guessVerifier);
        games.push(game);
        
        emit GameCreated(_host, _player, _initVerifier, _guessVerifier);
    }
}
