pragma solidity ^0.5.0;

import "./BaseMultiKyber.sol";


contract IFulcrumToken is IERC20 {
    function tokenPrice() external view returns(uint256);
    function loanTokenAddress() external view returns(address);

    function mintWithEther(
        address receiver
    )
        external
        payable
        returns (uint256 mintAmount);

    function mint(
        address receiver,
        uint256 depositAmount
    )
        external
        returns (uint256 mintAmount);

    function burnToEther(
        address receiver,
        uint256 burnAmount
    )
        external
        returns (uint256 loanAmountPaid);

    function burn(
        address receiver,
        uint256 burnAmount
    )
        external
        returns (uint256 loanAmountPaid);
}


contract FulcrumMultiKyber is BaseMultiKyber {

    function() external payable {
        // solium-disable-next-line security/no-tx-origin
        require(msg.sender != tx.origin);
    }

    function getExpectedRate(IERC20 src, IERC20 dest, uint srcQty)
        public
        view
        returns(uint256 expectedRate, uint256 slippageRate)
    {
        // fulcrum

        IERC20 underlying;

        underlying = isFulcrumToken(src);
        if (underlying != IERC20(0)) {
            uint256 fulcrumRate = IFulcrumToken(address(src)).tokenPrice();

            uint256 srcDecimals = decimalsOf(src);
            uint256 underDecimals = decimalsOf(underlying);

            (expectedRate, slippageRate) = getExpectedRate(
                underlying,
                dest,
                srcQty.mul(fulcrumRate).div(1e18)
            );

            return (
                expectedRate.mul(fulcrumRate).mul(10**srcDecimals).mul(10**uint256(18).sub(underDecimals)).div(1e18).div(1e18),
                slippageRate.mul(fulcrumRate).mul(10**srcDecimals).mul(10**uint256(18).sub(underDecimals)).div(1e18).div(1e18)
            );
        }

        underlying = isFulcrumToken(dest);
        if (underlying != IERC20(0)) {
            (expectedRate, slippageRate) = getExpectedRate(
                src,
                underlying,
                srcQty
            );

            uint256 fulcrumRate = IFulcrumToken(address(dest)).tokenPrice();
            uint256 destDecimals = decimalsOf(dest);
            uint256 underDecimals = decimalsOf(underlying);

            return (
                expectedRate.mul(1e18).mul(1e18).div(10**destDecimals).div(10**uint256(18).sub(underDecimals)).div(fulcrumRate),
                slippageRate.mul(1e18).mul(1e18).div(10**destDecimals).div(10**uint256(18).sub(underDecimals)).div(fulcrumRate)
            );
        }

        return super.getExpectedRate(src, dest, srcQty);
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
        IERC20 underlying;

        underlying = isFulcrumToken(src);
        if (underlying != IERC20(0)) {

            if (underlying == ETH) {
                IFulcrumToken(address(src)).burnToEther(address(this), srcAmount);
            } else {
                IFulcrumToken(address(src)).burn(address(this), srcAmount);
            }

            uint256 underlyingAmount = balanceOf(underlying, address(this));

            if (underlying != ETH) {
                if (underlying.allowance(address(this), address(kyber)) == 0) {
                    underlying.safeApprove(address(kyber), uint256(-1));
                }
            }

            return this.tradeWithHint(
                underlying,
                underlyingAmount,
                dest,
                destAddress,
                maxDestAmount,
                minConversionRate,
                walletId,
                hint
            );
        }

        underlying = isFulcrumToken(dest);
        if (underlying != IERC20(0)) {
            if (src != ETH) {
                if (src.allowance(address(this), address(kyber)) == 0) {
                    src.safeApprove(address(kyber), uint256(-1));
                }
            }

            uint256 returnAmount = this.tradeWithHint(
                src,
                srcAmount,
                underlying,
                address(this),
                maxDestAmount,
                minConversionRate,
                walletId,
                hint
            );

            if (underlying == ETH) {
                IFulcrumToken(address(dest)).mintWithEther.value(returnAmount)(address(this));
            } else {
                if (underlying.allowance(address(this), address(dest)) == 0) {
                    underlying.safeApprove(address(dest), uint256(-1));
                }
                IFulcrumToken(address(dest)).mint(address(this), returnAmount);
            }
            uint256 balance = balanceOf(dest, address(this));
            dest.safeTransfer(destAddress, balance);
            return balance;
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

    function isFulcrumToken(IERC20 token) public view returns(IERC20) {
        if (token == ETH) {
            return IERC20(0);
        }

        (bool success, bytes memory data) = address(token).staticcall.gas(2300)(abi.encodeWithSelector(
            IFulcrumToken(address(token)).loanTokenAddress.selector
        ));

        if (!success) {
            return IERC20(0);
        }

        IERC20 underlying;
        assembly {
            underlying := mload(add(data, 32))
        }

        return underlying;
    }
}
