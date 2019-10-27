pragma solidity ^0.5.0;

import "./CompoundMultiKyber.sol";


contract MultiKyber is CompoundMultiKyber {
    constructor(IKyber _kyber, ICompound _compound, ICompoundEther _cETH)
        public
        CompoundMultiKyber(_kyber, _compound, _cETH)
    {
    }
}
