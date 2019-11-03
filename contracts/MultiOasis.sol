pragma solidity ^0.5.0;

import "./BaseMultiOasis.sol";
import "./ChildMultiExchange.sol";
import "./CompoundMultiExchange.sol";
import "./FulcrumMultiExchange.sol";
import "./WrappedMultiExchange.sol";


contract MultiOasis is
    BaseMultiOasis,
    CompoundMultiExchange,
    FulcrumMultiExchange,
    WrappedMultiExchange,
    ChildMultiExchange,
    IOasis
{
    constructor(
        IOasis _oasis,
        ICompound _compound,
        ICompoundEther _cETH
    )
        public
        BaseMultiOasis(_oasis)
        CompoundMultiExchange(_compound, _cETH)
    {
    }

    function getBuyAmount(
        IERC20 buyGem,
        IERC20 payGem,
        uint256 payAmt
    )
        public
        view
        returns(uint256 fillAmt)
    {
        return payAmt.mul(1e18).div(getPrice(payGem, buyGem, payAmt));
    }

    function sellAllAmount(
        IERC20 payGem,
        uint256 payAmt,
        IERC20 buyGem,
        uint256 minFillAmount
    )
        public
        payable
        returns(uint256 fillAmt)
    {
        fillAmt = swap(payGem, payAmt, buyGem, msg.sender, address(0));
        require(fillAmt >= minFillAmount);
    }
}
