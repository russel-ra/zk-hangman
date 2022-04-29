# DISCLAIMER
This is an MVP and as such has very little polish and missing features. See the potential
improvements section below for ways in which this project could be made better. 

# zk-hangman
Circuits and contracts for zk-hangman.  

## Brief overview

If you've played hangman before, the rules are exactly the same, except with zk-hangman
we utilize zero-knowledge proofs and smart contracts to play the game on-chain in an 
entirely trustless manner. There are some constraints in place with the MVP, one of them
being that the secret word must have a fixed length of 5 characters.

The game consists of two players: the host and the player. The host must initialize the
game with the secret 5 character word and the player must guess the word character by
character with a limited number of invalid guesses (which is 6 in our case). 

The game starts with the host generating a zk proof from the 5 characters that will make 
up the word the player will try to guess, and a secret number. We will see why we need this 
secret number later. The proof circuit takes in the 5 characters as integers from 0-25 
representing each letter of the alphabet from a to z. It then outputs 5 character hashes
which are hashes of the character (represented as an integer from 0-25) and the secret that 
the host inputted. It also outputs the hash of the secret which we will use later. All these
hashes are stored on-chain on the smart contract. 

It is then the player's turn. The player must submit a character (represented as an integer
from 0-25) as their guess. It must be a character that has not been guessed before. Once the
user submits their guess, control is passed to the host to process the guess.

The host processes the guess by submitting a proof that takes in the latest guess by the player
as a public input and the secret as a private input. The proof outputs a hash of the input by the 
player plus the secret and a hash of the secret on its own. By doing so, we can compare the secret
hash with the one stored on-chain to ensure that the host really did use the secret they initially
set. We can tell if the guess was valid, by looking at its hash (with the secret) and comparing
it to all the other character hashes stored on-chain. If the hash matches none of the ones
stored on-chain, then we know the guess was invalid and the player's life is deducted by one.

The process described above continues until the player has run out of all 6 lives OR the player
finally guesses all characters in the word correctly. In the former case, the host wins in
the latter, the player. 

# Potential improvements
- Accept variable length words with a maximum and minimum range (e.g. minimum 5 maximum 12)
- Add input validation to the frontend so the user does not enter invalid inputs and cause the contract to revert
- Add a game over screen to the frontend. 
- General UI/UX improvements
