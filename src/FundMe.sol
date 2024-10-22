// get fund from user
// withdraw funds
// set a minimum funding value in USD

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "lib/chainlink-brownie-contracts//contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import "src/PriceConverter.sol";

error FundMe__NotOwner();

contract FundMe {
    using PriceConverter for uint256;

    uint256 public constant MINIMUM_USD = 50 * 1e18;
    address[] private s_funders;
    mapping(address => uint256) private s_addresstoAmountFunded;
    AggregatorV3Interface private s_pricefeed;

    address private immutable i_owner;

    constructor(address priceFeed) {
        i_owner = msg.sender;
        s_pricefeed = AggregatorV3Interface(priceFeed);
    }

    function fund() public payable {
        require(
            msg.value.getConversionRate(s_pricefeed) >= MINIMUM_USD,
            "didn't enough to send"
        );
        s_funders.push(msg.sender);
        s_addresstoAmountFunded[msg.sender] += msg.value;
    }

    function cheaperWithDraw() public onlyOwner {
        uint256 funderLength = s_funders.length;
        for (
            uint256 funderindex = 0;
            funderindex < funderLength;
            funderindex++
        ) {
            address funder = s_funders[funderindex];
            s_addresstoAmountFunded[funder] = 0;
        }
        s_funders = new address[](0);

        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSuccess, "call failed");
    }

    function withdraw() public onlyOwner {
        for (
            uint256 funderindex = 0;
            funderindex < s_funders.length;
            funderindex++
        ) {
            address funder = s_funders[funderindex];
            s_addresstoAmountFunded[funder] = 0;
        }
        //reset the array
        s_funders = new address[](0);

        // //send using three ways

        // //transfer
        // payable(msg.sender).transfer(address(this).balance);

        // //send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess,"Sent Failed");

        //call
        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSuccess, "call failed");
    }

    modifier onlyOwner() {
        require(msg.sender == i_owner, "sender is not a owner");
        _;
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }

    function getVersion() public view returns (uint256) {
        return s_pricefeed.version();
    }

    function getAddressToAmountFunded(
        address funding_address
    ) external view returns (uint256) {
        return s_addresstoAmountFunded[funding_address];
    }

    function getFunder(uint256 index) external view returns (address) {
        return s_funders[index];
    }

    function getOwner() external view returns (address) {
        return i_owner;
    }
}
