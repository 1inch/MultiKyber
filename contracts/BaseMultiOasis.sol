pragma solidity ^0.5.0;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20Detailed.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";

import "./BaseMultiExchange.sol";
import "./IOasis.sol";


contract BaseMultiOasis is BaseMultiExchange {

    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    IERC20 public constant ETH = IERC20(0);

    IOasis public oasis; // 0x39755357759cE0d7f32dC8dC45414CCa409AE24e

    constructor(IOasis _oasis) public {
        oasis = _oasis;
    }

    function getPrice(IERC20 src, IERC20 dest, uint srcQty)
        public
        view
        returns(uint256 price)
    {
        if (src == dest) {
            return 1e18;
        }

        return oasis.getBuyAmount(dest, src, srcQty).mul(1e18).div(srcQty);
    }

    function swap(
        IERC20 src,
        uint srcAmount,
        IERC20 dest,
        address payable destAddress,
        address /*ref*/
    )
        public
        payable
        returns(uint256)
    {
        if (src == dest) {
            uint256 balance = src.balanceOf(address(this));
            if (destAddress != address(this)) {
                dest.safeTransfer(destAddress, balance);
            }
            return balance;
        }

        if (src != ETH) {
            if (src.allowance(address(this), address(oasis)) == 0) {
                src.safeApprove(address(oasis), uint256(-1));
            }
        }

        uint256 returnAmount = oasis.sellAllAmount(
            src,
            srcAmount,
            dest,
            0
        );

        if (destAddress != address(this)) {
            dest.safeTransfer(destAddress, returnAmount);
        }

        return returnAmount;
    }
}
