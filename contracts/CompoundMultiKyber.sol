pragma solidity ^0.5.0;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20Detailed.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";


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


interface IKyber {
    function getExpectedRate(IERC20 src, IERC20 dest, uint srcQty)
        external
        view
        returns(uint256 expectedRate, uint256 slippageRate);

    function tradeWithHint(
        IERC20 src,
        uint srcAmount,
        IERC20 dest,
        address payable destAddress,
        uint maxDestAmount,
        uint minConversionRate,
        address walletId,
        bytes calldata hint
    )
        external
        payable
        returns(uint256);
}


contract CompoundMultiKyber is IKyber {

    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    IERC20 public constant ETH = IERC20(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);

    IKyber public kyber;        // 0x818E6FECD516Ecc3849DAf6845e3EC868087B755
    ICompound public compound;  // 0x3d9819210A31b4961b30EF54bE2aeD79B9c9Cd3B
    ICompoundEther public cETH; // 0x4Ddc2D193948926D02f9B1fE9e1daa0718270ED5

    constructor(IKyber _kyber, ICompound _compound, ICompoundEther _cETH) public {
        kyber = _kyber;
        compound = _compound;
        cETH = _cETH;
    }

    function() external payable {
        // solium-disable-next-line security/no-tx-origin
        require(msg.sender != tx.origin);
    }

    function getExpectedRate(IERC20 src, IERC20 dest, uint srcQty)
        public
        view
        returns(uint256 expectedRate, uint256 slippageRate)
    {
        // Compound

        if (isCompoundToken(src)) {
            uint256 compoundRate = ICompoundToken(address(src)).exchangeRateStored();

            IERC20 underlying = compoundUnderlyingAsset(src);
            uint256 srcDecimals = decimalsOf(src);
            uint256 underDecimals = decimalsOf(underlying);

            (expectedRate, slippageRate) = getExpectedRate(
                underlying,
                dest,
                srcQty.mul(compoundRate).div(1e18)
            );

            return (
                expectedRate.mul(compoundRate).mul(10**srcDecimals).mul(10**uint256(18).sub(underDecimals)).div(1e18).div(1e18),
                slippageRate.mul(compoundRate).mul(10**srcDecimals).mul(10**uint256(18).sub(underDecimals)).div(1e18).div(1e18)
            );
        }

        if (isCompoundToken(dest)) {
            IERC20 underlying = compoundUnderlyingAsset(dest);

            (expectedRate, slippageRate) = getExpectedRate(
                src,
                underlying,
                srcQty
            );

            uint256 compoundRate = ICompoundToken(address(dest)).exchangeRateStored();
            uint256 destDecimals = decimalsOf(dest);
            uint256 underDecimals = decimalsOf(underlying);

            return (
                expectedRate.mul(1e18).mul(1e18).div(10**destDecimals).div(10**uint256(18).sub(underDecimals)).div(compoundRate),
                slippageRate.mul(1e18).mul(1e18).div(10**destDecimals).div(10**uint256(18).sub(underDecimals)).div(compoundRate)
            );
        }

        // Fallback

        if (src == dest) {
            return (1e18, 1e18);
        }

        return kyber.getExpectedRate(src, dest, srcQty);
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

        if (isCompoundToken(src)) {

            ICompoundToken(address(src)).redeem(srcAmount);

            IERC20 underlying = compoundUnderlyingAsset(src);
            uint256 underlyingAmount = balanceOf(underlying, address(this));

            if (underlying != ETH) {
                if (underlying.allowance(address(this), address(kyber)) != 0) {
                    underlying.safeApprove(address(kyber), 0);
                }
                underlying.safeApprove(address(kyber), underlyingAmount);
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

        if (isCompoundToken(dest)) {
            if (src != ETH) {
                if (src.allowance(address(this), address(kyber)) != 0) {
                    src.safeApprove(address(kyber), 0);
                }
                src.safeApprove(address(kyber), srcAmount);
            }

            IERC20 underlying = compoundUnderlyingAsset(dest);

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
                cETH.mint.value(returnAmount)();
            } else {
                if (underlying.allowance(address(this), address(dest)) != 0) {
                    underlying.safeApprove(address(dest), 0);
                }
                underlying.safeApprove(address(dest), returnAmount);
                ICompoundToken(address(dest)).mint(returnAmount);
            }
            uint256 balance = balanceOf(dest, address(this));
            dest.safeTransfer(destAddress, balance);
            return balance;
        }

        // Fallback

        if (src == dest) {
            uint256 balance;
            if (dest == ETH) {
                balance = address(this).balance;
                destAddress.transfer(balance);
            } else {
                balance = src.balanceOf(address(this));
                src.safeTransfer(destAddress, balance);
            }
            return balance;
        }

        return kyber.tradeWithHint.value(address(this).balance)(
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

    function balanceOf(IERC20 asset, address account) public view returns(uint256) {
        if (asset == ETH) {
            return account.balance;
        }
        return asset.balanceOf(account);
    }

    function decimalsOf(IERC20 asset) public view returns(uint256) {
        if (asset == ETH) {
            return 18;
        }
        return uint256(ERC20Detailed(address(asset)).decimals());
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
