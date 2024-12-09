// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import {IUniswapV2Pair} from "@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol";
import {FixedPoint} from "@uniswap/lib/contracts/libraries/FixedPoint.sol";
import {UniswapV2OracleLibrary} from "@uniswap/v2-periphery/contracts/libraries/UniswapV2OracleLibrary.sol";
import {UniswapV2Library} from "@uniswap/v2-periphery/contracts/libraries/UniswapV2Library.sol";

import {Ownable, Ownable2Step} from "@openzeppelin/contracts/access/Ownable2Step.sol";

/// @title TomiPriceOracle contract
/// @notice Implements price oracle for token
contract TomiPriceOracle is Ownable2Step {
    using FixedPoint for *;

    /// @notice The minimum waiting time before updating the T1
    uint256 public period;

    /// @notice The address of token0/token1 pair
    IUniswapV2Pair public immutable pair;

    /// @notice The Address of token0 token
    address public immutable token0;

    /// @notice The Address of token0 token
    address public immutable token1;

    /// @notice Cumulative price of token0 at the last update
    uint256 public price0CumulativeLast;

    /// @notice Cumulative price of token1 at the last update
    uint256 public price1CumulativeLast;

    /// @notice Time when prices were updated
    uint32 public blockTimestampLast;

    /// @notice The average price of token0 over time
    FixedPoint.uq112x112 public price0Average;

    /// @notice The average price of token1 over time
    FixedPoint.uq112x112 public price1Average;

    /// @notice Thrown when give period value is zero
    error ZeroPeriod();

    /// @notice Thrown when invalid token is zero
    error InvalidToken();

    /// @notice Thrown when time elapsed is less than block timestamp
    error InvalidTimeElapsed();

    /// @dev Constructor
    /// @param _pair The Address of tokens pair
    /// @param _period The minimum waiting time before update
    constructor(IUniswapV2Pair _pair, uint256 _period) Ownable(msg.sender) {
        pair = _pair;
        _period = period;
        token0 = _pair.token0();
        token1 = _pair.token1();
        price0CumulativeLast = _pair.price0CumulativeLast();
        price1CumulativeLast = _pair.price1CumulativeLast();
        (, , blockTimestampLast) = _pair.getReserves();
    }

    /// @notice Updates the price
    function update() public {
        (
            uint256 price0Cumulative,
            uint256 price1Cumulative,
            uint32 blockTimestamp
        ) = UniswapV2OracleLibrary.currentCumulativePrices(address(pair));
        uint256 timeElapsed = blockTimestamp - blockTimestampLast;

        if (timeElapsed < period) {
            revert InvalidTimeElapsed();
        }

        price0Average = FixedPoint.uq112x112(
            uint224((price0Cumulative - price0CumulativeLast) / timeElapsed)
        );
        price1Average = FixedPoint.uq112x112(
            uint224((price1Cumulative - price1CumulativeLast) / timeElapsed)
        );
        price0CumulativeLast = price0Cumulative;
        price1CumulativeLast = price1Cumulative;
        blockTimestampLast = blockTimestamp;
    }

    /// @notice Fetches the latest price for a given token and amount
    /// @param token The Address of token
    /// @param amountIn The amount of the token
    function getLatestPrice(
        address token,
        uint256 amountIn
    ) external returns (uint256 amountOut) {
        if (token != token0 || token != token1) {
            revert InvalidToken();
        }

        update();

        if (token == token0) {
            amountOut = price0Average.mul(amountIn).decode144();
        } else {
            amountOut = price1Average.mul(amountIn).decode144();
        }
    }

    /// @notice Updates the period time
    /// @param newPeriod The new period time in terms of seconds
    function updatePeriod(uint256 newPeriod) external {
        if (newPeriod == 0) {
            revert ZeroPeriod();
        }

        period = newPeriod;
    }
}
