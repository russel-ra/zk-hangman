pragma solidity ^0.8.0;

import './zkHangman.sol';

contract zkHangmanFactory {
    address[] public games;

    event GameCreated(address indexed host, address indexed player, address gameAddress, address initVerifier, address guessVerifier);

    function createGame(address _host, address _player, address _initVerifier, address _guessVerifier) public {
        zkHangman _game = new zkHangman(_host, _player, _initVerifier, _guessVerifier);
        games.push(address(_game));
        
        emit GameCreated(_host, _player, address(_game), _initVerifier, _guessVerifier);
    }
}
