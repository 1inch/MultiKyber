pragma solidity ^0.5.0;

import "./CompoundMultiKyber.sol";
import "./FulcrumMultiKyber.sol";


contract MultiKyber is CompoundMultiKyber, FulcrumMultiKyber {

    constructor(
        IKyber _kyber,
        ICompound _compound,
        ICompoundEther _cETH
    )
        public
        CompoundMultiKyber(_compound, _cETH)
    {
        kyber = _kyber;
    }

    function tradeWithHint(
        IERC20 src,
        uint srcAmount,
        IERC20 dest,
        address payable destAddress,
        uint maxDestAmount,
        uint minConversionRate,
        address walletId,
        bytes memory hint
    )
        public
        payable
        returns(uint256)
    {
        if (src != ETH && msg.sender != address(this)) {
            src.safeTransferFrom(msg.sender, address(this), srcAmount);
        }

        return super.tradeWithHint(
            src,
            srcAmount,
            dest,
            destAddress,
            maxDestAmount,
            minConversionRate,
            walletId,
            hint
        );
    }
}
