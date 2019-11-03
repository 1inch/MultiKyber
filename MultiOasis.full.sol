
// File: @openzeppelin/contracts/math/SafeMath.sol

pragma solidity ^0.5.0;

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, "SafeMath: division by zero");
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0, "SafeMath: modulo by zero");
        return a % b;
    }
}

// File: @openzeppelin/contracts/token/ERC20/IERC20.sol

pragma solidity ^0.5.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
 * the optional functions; to access them see `ERC20Detailed`.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a `Transfer` event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through `transferFrom`. This is
     * zero by default.
     *
     * This value changes when `approve` or `transferFrom` are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * > Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an `Approval` event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a `Transfer` event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to `approve`. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// File: @openzeppelin/contracts/token/ERC20/ERC20Detailed.sol

pragma solidity ^0.5.0;


/**
 * @dev Optional functions from the ERC20 standard.
 */
contract ERC20Detailed is IERC20 {
    string private _name;
    string private _symbol;
    uint8 private _decimals;

    /**
     * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
     * these values are immutable: they can only be set once during
     * construction.
     */
    constructor (string memory name, string memory symbol, uint8 decimals) public {
        _name = name;
        _symbol = symbol;
        _decimals = decimals;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5,05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei.
     *
     * > Note that this information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * `IERC20.balanceOf` and `IERC20.transfer`.
     */
    function decimals() public view returns (uint8) {
        return _decimals;
    }
}

// File: @openzeppelin/contracts/utils/Address.sol

pragma solidity ^0.5.0;

/**
 * @dev Collection of functions related to the address type,
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * This test is non-exhaustive, and there may be false-negatives: during the
     * execution of a contract's constructor, its address will be reported as
     * not containing a contract.
     *
     * > It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies in extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(account) }
        return size > 0;
    }
}

// File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol

pragma solidity ^0.5.0;




/**
 * @title SafeERC20
 * @dev Wrappers around ERC20 operations that throw on failure (when the token
 * contract returns false). Tokens that return no value (and instead revert or
 * throw on failure) are also supported, non-reverting calls are assumed to be
 * successful.
 * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    function safeApprove(IERC20 token, address spender, uint256 value) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require((value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(value);
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(value);
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function callOptionalReturn(IERC20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves.

        // A Solidity high level call has three parts:
        //  1. The target address is checked to verify it contains contract code
        //  2. The call itself is made, and success asserted
        //  3. The return value is decoded, which in turn checks the size of the returned data.
        // solhint-disable-next-line max-line-length
        require(address(token).isContract(), "SafeERC20: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = address(token).call(data);
        require(success, "SafeERC20: low-level call failed");

        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

// File: contracts/BaseMultiExchange.sol

pragma solidity ^0.5.0;






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

// File: contracts/IOasis.sol

pragma solidity ^0.5.0;



contract IOasis {

    function getBuyAmount(IERC20 buyGem, IERC20 payGem, uint payAmt) public view returns (uint fillAmt);

    function sellAllAmount(IERC20 payGem, uint payAmt, IERC20 buyGem, uint minFillAmount) public returns (uint fillAmt);
}

// File: contracts/BaseMultiOasis.sol

pragma solidity ^0.5.0;








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

// File: contracts/ChildMultiExchange.sol

pragma solidity ^0.5.0;



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

// File: contracts/CompoundMultiExchange.sol

pragma solidity ^0.5.0;



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

// File: contracts/FulcrumMultiExchange.sol

pragma solidity ^0.5.0;



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


contract FulcrumMultiExchange is BaseMultiExchange {

    function() external payable {
        // solium-disable-next-line security/no-tx-origin
        require(msg.sender != tx.origin);
    }

    function getPrice(IERC20 src, IERC20 dest, uint srcQty)
        public
        view
        returns(uint256 price)
    {
        // fulcrum

        IERC20 underlying;

        underlying = isFulcrumToken(src);
        if (underlying != IERC20(0)) {
            uint256 fulcrumRate = IFulcrumToken(address(src)).tokenPrice();

            uint256 srcDecimals = decimalsOf(src);
            uint256 underDecimals = decimalsOf(underlying);

            price = getPrice(
                underlying,
                dest,
                srcQty.mul(fulcrumRate).div(1e18)
            );

            return price.mul(fulcrumRate).mul(10**srcDecimals).mul(10**uint256(18).sub(underDecimals)).div(1e18).div(1e18);
        }

        underlying = isFulcrumToken(dest);
        if (underlying != IERC20(0)) {
            price = getPrice(
                src,
                underlying,
                srcQty
            );

            uint256 fulcrumRate = IFulcrumToken(address(dest)).tokenPrice();
            uint256 destDecimals = decimalsOf(dest);
            uint256 underDecimals = decimalsOf(underlying);

            return price.mul(1e18).mul(1e18).div(10**destDecimals).div(10**uint256(18).sub(underDecimals)).div(fulcrumRate);
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
        IERC20 underlying;

        underlying = isFulcrumToken(src);
        if (underlying != IERC20(0)) {

            if (underlying == ETH) {
                IFulcrumToken(address(src)).burnToEther(address(this), srcAmount);
            } else {
                IFulcrumToken(address(src)).burn(address(this), srcAmount);
            }

            uint256 underlyingAmount = balanceOf(underlying, address(this));

            return this.swap(
                underlying,
                underlyingAmount,
                dest,
                destAddress,
                ref
            );
        }

        underlying = isFulcrumToken(dest);
        if (underlying != IERC20(0)) {
            uint256 returnAmount = this.swap(
                src,
                srcAmount,
                underlying,
                address(this),
                ref
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

        return super.swap(
            src,
            srcAmount,
            dest,
            destAddress,
            ref
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
        assembly { // solium-disable-line security/no-inline-assembly
            underlying := mload(add(data, 32))
        }

        return underlying;
    }
}

// File: contracts/WrappedMultiExchange.sol

pragma solidity ^0.5.0;



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

// File: contracts/MultiOasis.sol

pragma solidity ^0.5.0;







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
        returns(uint256 fillAmt)
    {
        fillAmt = swap(payGem, payAmt, buyGem, msg.sender, address(0));
        require(fillAmt >= minFillAmount);
    }
}
