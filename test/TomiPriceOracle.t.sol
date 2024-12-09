// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.25;

import {Test, console} from "../lib/forge-std/src/Test.sol";

import {IUniswapV2Factory} from "@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol";
import {IUniswapV2Pair} from "@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol";
// import {FixedPoint} from "@uniswap/lib/contracts/libraries/FixedPoint.sol";

import {TomiPriceOracle} from "../contracts/TomiPriceOracle.sol";

contract TomiPriceOracleTest is Test {
    address tomiToken;
    address public usdtToken;
    address public uniswapFactory;
    address public factoryMain;
    uint256 public lastPrice;
    uint256 public lastTimestamp;
    IUniswapV2Pair public pair;
    TomiPriceOracle public priceOracle;

    address public tomi = 0x4385328cc4D643Ca98DfEA734360C0F596C83449;
    address public usdt = 0xdAC17F958D2ee523a2206206994597C13D831ec7;

    // FixedPoint.uq112x112 public priceAverage;

    function setUp() public {
        tomiToken = 0x9a361D70AbCB983964DDA52E18d790906A761aDC;
        usdtToken = 0x6fEA2f1b82aFC40030520a6C49B0d3b652A65915;
        uniswapFactory = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;
        factoryMain = 0xF62c03E08ada871A0bEb309762E260a7a6a880E6;
        lastTimestamp = block.timestamp;

        // pair = IUniswapV2Pair(
        //     IUniswapV2Factory(uniswapFactory).getPair(tomiToken, usdtToken)
        // );

        pair = IUniswapV2Pair(
            IUniswapV2Factory(uniswapFactory).getPair(tomi, usdt)
        );

        priceOracle = new TomiPriceOracle(pair);
    }

    function test_GetlatestPrice() external {
        priceOracle.update();
        uint256 price = priceOracle.getLatestPrice(tomi, 1e18);
        console.log("price -------", price);
    }
}
