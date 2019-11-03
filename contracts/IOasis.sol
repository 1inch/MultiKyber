pragma solidity ^0.5.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";


contract IOasis {

    function getBuyAmount(IERC20 buyGem, IERC20 payGem, uint payAmt) public view returns (uint fillAmt);

    function sellAllAmount(IERC20 payGem, uint payAmt, IERC20 buyGem, uint minFillAmount) public payable returns (uint fillAmt);
}