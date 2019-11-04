pragma solidity ^0.5.0;

import "./BaseMultiKyber.sol";
import "./ChildMultiExchange.sol";
import "./UnwrappedMultiExchange.sol";
import "./CompoundMultiExchange.sol";
import "./FulcrumMultiExchange.sol";


contract MultiKyber is
    BaseMultiKyber,
    UnwrappedMultiExchange,
    CompoundMultiExchange,
    FulcrumMultiExchange,
    ChildMultiExchange,
    IKyber
{
    constructor(
        IKyber _kyber,
        ICompound _compound,
        ICompoundEther _cETH
    )
        public
        BaseMultiKyber(_kyber)
        CompoundMultiExchange(_compound, _cETH)
    {
    }

    function getExpectedRate(IERC20 src, IERC20 dest, uint srcQty)
        public
        view
        returns(uint256 expectedRate, uint256 slippageRate)
    {
        return (getPrice(src, dest, srcQty), 0);
    }

    function tradeWithHint(
        IERC20 src,
        uint srcAmount,
        IERC20 dest,
        address payable destAddress,
        uint /*maxDestAmount*/,
        uint minConversionRate,
        address walletId,
        bytes memory /*hint*/
    )
        public
        payable
        returns(uint256)
    {
        uint256 returnAmount = swap(
            src,
            srcAmount,
            dest,
            destAddress,
            walletId
        );

        require(
            returnAmount.mul(1e18).div(srcAmount) >= minConversionRate,
            "Actual conversion rate was lower than minConversionRate"
        );

        return returnAmount;
    }
}
