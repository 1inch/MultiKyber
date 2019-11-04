pragma solidity ^0.5.0;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20Detailed.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";


contract BaseMultiExchange {

    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    IERC20 public constant ETH = IERC20(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);

    function getPrice(IERC20 /*src*/, IERC20 /*dest*/, uint /*srcQty*/)
        public
        view
        returns(uint256 /*price*/)
    {
        this;
        revert("Not implemented");
    }

    function swap(
        IERC20 /*src*/,
        uint /*srcAmount*/,
        IERC20 /*dest*/,
        address payable /*destAddress*/,
        address /*ref*/
    )
        public
        payable
        returns(uint256)
    {
        this;
        revert("Not implemented");
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
}
