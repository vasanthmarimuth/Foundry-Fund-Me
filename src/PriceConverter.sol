// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "lib/chainlink-brownie-contracts//contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    function getPrice(
        AggregatorV3Interface pricefeed
    ) internal view returns (uint256) {
        //ABI
        //Address ETH / USD  0x694AA1769357215DE4FAC081bf1f309aDC325306
        (, int256 answer, , , ) = pricefeed.latestRoundData();
        return uint256(answer * 1e10);
    }

    function getVersion(
        AggregatorV3Interface pricefeed
    ) public view returns (uint256) {
        return pricefeed.version();
    }

    function getConversionRate(
        uint256 ethAmount,
        AggregatorV3Interface pricefeed
    ) internal view returns (uint256) {
        uint256 ethPrice = getPrice(pricefeed);
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    }
}
