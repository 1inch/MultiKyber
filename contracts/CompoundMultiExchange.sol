pragma solidity ^0.5.0;

import "./BaseMultiExchange.sol";


contract ICompound {
    function markets(address cToken)
        external
        view
        returns(bool isListed, uint256 collateralFactorMantissa);
}


contract ICompoundToken is IERC20 {
    function underlying() external view returns(address);
    function exchangeRateStored() external view returns(uint256);

    function mint(uint256 mintAmount) external returns(uint256);
    function redeem(uint256 redeemTokens) external returns(uint256);
}


contract ICompoundEther is IERC20 {
    function mint() external payable;
    function redeem(uint256 redeemTokens) external returns(uint256);
}


contract CompoundMultiExchange is BaseMultiExchange {

    ICompound public compound;  // 0x3d9819210A31b4961b30EF54bE2aeD79B9c9Cd3B
    ICompoundEther public cETH; // 0x4Ddc2D193948926D02f9B1fE9e1daa0718270ED5

    constructor(ICompound _compound, ICompoundEther _cETH) public {
        compound = _compound;
        cETH = _cETH;
    }

    function() external payable {
        // solium-disable-next-line security/no-tx-origin
        require(msg.sender != tx.origin);
    }

    function getPrice(IERC20 src, IERC20 dest, uint srcQty)
        public
        view
        returns(uint256 price)
    {
        if (isCompoundToken(src)) {
            uint256 compoundRate = ICompoundToken(address(src)).exchangeRateStored();

            IERC20 underlying = compoundUnderlyingAsset(src);
            uint256 srcDecimals = decimalsOf(src);
            uint256 underDecimals = decimalsOf(underlying);

            price = getPrice(
                underlying,
                dest,
                srcQty.mul(compoundRate).div(1e18)
            );

            return price.mul(compoundRate).mul(10**srcDecimals).mul(10**uint256(18).sub(underDecimals)).div(1e18).div(1e18);
        }

        if (isCompoundToken(dest)) {
            IERC20 underlying = compoundUnderlyingAsset(dest);

            price = getPrice(
                src,
                underlying,
                srcQty
            );

            uint256 compoundRate = ICompoundToken(address(dest)).exchangeRateStored();
            uint256 destDecimals = decimalsOf(dest);
            uint256 underDecimals = decimalsOf(underlying);

            return price.mul(1e18).mul(1e18).div(10**destDecimals).div(10**uint256(18).sub(underDecimals)).div(compoundRate);
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
        if (isCompoundToken(src)) {

            ICompoundToken(address(src)).redeem(srcAmount);

            IERC20 underlying = compoundUnderlyingAsset(src);
            uint256 underlyingAmount = balanceOf(underlying, address(this));

            return this.swap(
                underlying,
                underlyingAmount,
                dest,
                destAddress,
                ref
            );
        }

        if (isCompoundToken(dest)) {
            IERC20 underlying = compoundUnderlyingAsset(dest);

            uint256 returnAmount = this.swap(
                src,
                srcAmount,
                underlying,
                address(this),
                ref
            );

            if (underlying == ETH) {
                cETH.mint.value(returnAmount)();
            } else {
                if (underlying.allowance(address(this), address(dest)) == 0) {
                    underlying.safeApprove(address(dest), uint256(-1));
                }
                ICompoundToken(address(dest)).mint(returnAmount);
            }
            uint256 balance = balanceOf(dest, address(this));
            dest.safeTransfer(destAddress, balance);
            return balance;
        }

        return super.swap(
            src,
            srcAmount,
            dest,
            destAddress,
            ref
        );
    }

    function isCompoundToken(IERC20 token) public view returns(bool) {
        (bool isListed,) = compound.markets(address(token));
        return token == cETH || isListed;
    }

    function compoundUnderlyingAsset(IERC20 asset) public view returns(IERC20) {
        if (asset == cETH) {
            return ETH;
        }
        return IERC20(ICompoundToken(address(asset)).underlying());
    }
}
