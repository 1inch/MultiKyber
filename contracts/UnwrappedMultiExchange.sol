pragma solidity ^0.5.0;

import "./BaseMultiExchange.sol";


contract IWETH is IERC20 {
    function deposit() public payable;
    function withdraw(uint wad) public;
}


contract UnwrappedMultiExchange is BaseMultiExchange {

    using SafeERC20 for IWETH;

    IWETH public constant WETH = IWETH(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);

    function() external payable {
        // solium-disable-next-line security/no-tx-origin
        require(msg.sender != tx.origin);
    }

    function getPrice(IERC20 src, IERC20 dest, uint srcQty)
        public
        view
        returns(uint256 price)
    {
        if (isWrapper(src)) {
            return getPrice(
                ETH,
                dest,
                srcQty
            );
        }

        if (isWrapper(dest)) {
            return getPrice(
                src,
                ETH,
                srcQty
            );
        }

        return super.getPrice(src, dest, srcQty);
    }

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
        if (isWrapper(src)) {

            WETH.withdraw(srcAmount);

            return this.swap(
                ETH,
                srcAmount,
                dest,
                destAddress,
                ref
            );
        }

        if (isWrapper(dest)) {
            uint256 returnAmount = this.swap(
                src,
                srcAmount,
                ETH,
                address(this),
                ref
            );

            WETH.deposit.value(returnAmount)();
            WETH.safeTransfer(destAddress, returnAmount);
            return returnAmount;
        }

        return super.swap(
            src,
            srcAmount,
            dest,
            destAddress,
            ref
        );
    }

    function isWrapper(IERC20 token) public pure returns(bool) {
        return (token == WETH);
    }
}
