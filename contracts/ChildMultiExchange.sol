pragma solidity ^0.5.0;

import "./BaseMultiExchange.sol";


contract ChildMultiExchange is BaseMultiExchange {

    function swap(
        IERC20 src,
        uint srcAmount,
        IERC20 dest,
        address payable destAddress,
        address ref
    )
        public
        payable
        returns(uint256)
    {
        if (src != ETH && msg.sender != address(this)) {
            src.safeTransferFrom(msg.sender, address(this), srcAmount);
        }

        return super.swap(
            src,
            srcAmount,
            dest,
            destAddress,
            ref
        );
    }
}
