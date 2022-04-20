pragma circom 2.0.0;

include "../circomlib/mimcsponge.circom";
include "../circomlib/comparators.circom";

template init() {
    signal input secret;
    signal input char[5];

    signal output secretHash;
    signal output charHash[5];

    component leqt[5];
    component geqt[5];

    // characters are represented as digits between 0-25 inclusive

    for (var i = 0; i < 5; i++) {
        leqt[i] = LessEqThan(32);
        leqt[i].in[0] <== char[i];
        leqt[i].in[1] <== 25; 

        leqt[i].out === 1;

        geqt[i] = GreaterEqThan(32);
        geqt[i].in[0] <== char[i];
        geqt[i].in[1] <== 0; 

        geqt[i].out === 1;
    }

    // calculate secret hash

    component mimcSecret = MiMCSponge(1, 220, 1);

    mimcSecret.ins[0] <== secret;
    mimcSecret.k <== 0;

    secretHash <== mimcSecret.outs[0];

    // calculate character hashes

    component charMimc[5];

    for (var i = 0; i < 5; i++) {
        charMimc[i] = MiMCSponge(2, 220, 1);

        charMimc[i].ins[0] <== char[i];
        charMimc[i].ins[1] <== secret;
        charMimc[i].k <== 0;
        
        charHash[i] <== charMimc[i].outs[0];
    }

}

component main = init();
