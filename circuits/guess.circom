pragma circom 2.0.0;

include "mimcsponge.circom";

template guess() {
    signal input char;
    signal input secret;

    signal output secretHash;
    signal output charHash;

    // calculate secret hash

    component mimcSecret = MiMCSponge(1, 220, 1);

    mimcSecret.ins[0] <== secret;
    mimcSecret.k <== 0;

    secretHash <== mimcSecret.outs[0];

    // calculate character hash which is hash(char, secret)

    component mimcChar = MiMCSponge(2, 220, 1);
    
    mimcChar.ins[0] <== char;
    mimcChar.ins[1] <== secret;
    mimcChar.k <== 0;

    charHash <== mimcChar.outs[0];

}

component main {public [char] } = guess();
