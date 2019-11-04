pragma solidity ^0.5.0;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20Detailed.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";

import "./BaseMultiExchange.sol";
import "./IKyber.sol";


contract BaseMultiKyber is BaseMultiExchange {

    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    IERC20 public constant ETH = IERC20(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);

    IKyber public kyber; // 0x818E6FECD516Ecc3849DAf6845e3EC868087B755

    constructor(IKyber _kyber) public {
        kyber = _kyber;
    }

    function getPrice(IERC20 src, IERC20 dest, uint srcQty)
        public
        view
        returns(uint256 price)
    {
        if (src == dest) {
            return 1e18;
        }

        (price,) = kyber.getExpectedRate(src, dest, srcQty);
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

        if (src != ETH) {
            if (src.allowance(address(this), address(kyber)) == 0) {
                src.safeApprove(address(kyber), uint256(-1));
            }
        }

        return kyber.tradeWithHint.value(address(this).balance)(
            src,
            srcAmount,
            dest,
            destAddress,
            1 << 255,
            0,
            ref,
            ""
        );
    }
}
