pragma solidity ^0.5.0;

import "./BaseMultiExchange.sol";


contract IWETH is IERC20 {
    function deposit() public payable;
    function withdraw(uint wad) public;
}


contract WrappedMultiExchange is BaseMultiExchange {

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
        if (isEther(src)) {
            return getPrice(
                WETH,
                dest,
                srcQty
            );
        }

        if (isEther(dest)) {
            return getPrice(
                src,
                WETH,
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
        if (isEther(src)) {

            WETH.deposit.value(srcAmount)();

            return this.swap(
                WETH,
                srcAmount,
                dest,
                destAddress,
                ref
            );
        }

        if (isEther(dest)) {
            uint256 returnAmount = this.swap(
                src,
                srcAmount,
                WETH,
                address(this),
                ref
            );

            WETH.withdraw(returnAmount);
            destAddress.transfer(returnAmount);
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

    function isEther(IERC20 token) public pure returns(bool) {
        return (token == ETH || token == IERC20(0));
    }
}
