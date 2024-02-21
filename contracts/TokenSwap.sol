// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TokenSwap {
    address public tokenFrom;
    address public tokenTo;
    uint256 public swapRate;
    string stakeOwner;

    event Swapped(address indexed from, uint256 amountFrom, uint256 amountTo);

    constructor(address _tokenFrom, address _tokenTo, uint256 _swapRate) {
        tokenFrom = _tokenFrom;
        tokenTo = _tokenTo;
        swapRate = _swapRate;
    }

    function swapTokenFromForTokenTo(
        uint256 _amount // uint256 _minAmountOut
    ) external {
        require(
            IERC20(tokenFrom).allowance(msg.sender, address(this)) >= _amount,
            "Insufficient allowance"
        );
        require(
            IERC20(tokenFrom).balanceOf(msg.sender) >= _amount,
            "Insufficient balance"
        );

        // Calculate the equivalent amount of tokenTo based on the swap rate
        uint256 equivalentAmountTo = (_amount * swapRate) / 1e18;
        // require(equivalentAmountTo >= _minAmountOut, "Slippage protection");

        // Transfer tokenFrom from the sender to this contract
        IERC20(tokenFrom).transferFrom(msg.sender, address(this), _amount);

        // Transfer tokenTo to the sender
        IERC20(tokenTo).transfer(msg.sender, equivalentAmountTo);

        // Emit the Swapped event
        emit Swapped(msg.sender, _amount, equivalentAmountTo);
    }

    function swapTokenToForTokenFrom(
        uint256 _amount // uint256 _minAmountOut
    ) external {
        require(
            IERC20(tokenTo).allowance(msg.sender, address(this)) >= _amount,
            "Insufficient allowance"
        );
        require(
            IERC20(tokenTo).balanceOf(msg.sender) >= _amount,
            "Insufficient balance"
        );

        // Calculate the equivalent amount of tokenFrom based on the inverse of the swap rate
        uint256 equivalentAmountFrom = (_amount * 1e18) / swapRate;
        // require(equivalentAmountFrom >= _minAmountOut, "Slippage protection");

        // Transfer tokenTo from the sender to this contract
        IERC20(tokenTo).transferFrom(msg.sender, address(this), _amount);

        // Transfer tokenFrom to the sender
        IERC20(tokenFrom).transfer(msg.sender, equivalentAmountFrom);

        // Emit the Swapped event
        emit Swapped(msg.sender, _amount, equivalentAmountFrom);
    }
}
