const hre = require("hardhat");
const { run } = require("hardhat");
require("dotenv").config();

async function verify(address, constructorArguments) {
  console.log(`verify  ${address} with arguments ${constructorArguments.join(',')}`)
  await run("verify:verify", {
    address,
    constructorArguments
  })
}

const tomiTokenAddress = '0x9a361D70AbCB983964DDA52E18d790906A761aDC'
const usdtTokenAddress = '0x6fea2f1b82afc40030520a6c49b0d3b652a65915'
const uniswapFactoryAddress = '0xF62c03E08ada871A0bEb309762E260a7a6a880E6'
const lastPriceInit = 115144997802617271460224866n


async function main() {

  const TomiTwap = await hre.ethers.deployContract("TomiTwap", [tomiTokenAddress, usdtTokenAddress, uniswapFactoryAddress, lastPriceInit]);

  console.log("Deploying TomiTwap...");

  await TomiTwap.waitForDeployment();

  console.log("TomiTwap deployed to:", TomiTwap.target);

  await new Promise(resolve => setTimeout(resolve, 20000));
  verify(TomiTwap.target, [tomiTokenAddress, usdtTokenAddress, uniswapFactoryAddress, lastPriceInit])
}

main();