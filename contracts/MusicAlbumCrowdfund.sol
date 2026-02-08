// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./FanToken.sol";

/*
 MusicAlbumCrowdfund
 - Artist creates a campaign to fund a music album
 - Fans contribute ETH
 - Deadline based finalization
 - Successful → artist withdraws ETH
 - Failed → fans get refunds
 - Fans receive ERC-20 reward tokens for support
*/

contract MusicAlbumCrowdfund {

    struct Campaign {
        address payable creator;
        string title;
        uint256 goalWei;
        uint256 deadline;
        uint256 totalRaised;
        bool finalized;
        bool successful;
    }

    FanToken public fanToken;
    uint256 public rewardRate; // tokens per 1 ETH
    uint256 public campaignCount;

    mapping(uint256 => Campaign) public campaigns;
    mapping(uint256 => mapping(address => uint256)) public contributions;

    constructor(address fanTokenAddress, uint256 _rewardRate) {
        fanToken = FanToken(fanTokenAddress);
        rewardRate = _rewardRate;
    }

    // Create a new crowdfunding campaign
    function createCampaign(
        string memory _title,
        uint256 _goalWei,
        uint256 _durationSeconds
    ) external {
        require(_goalWei > 0, "Goal must be greater than 0");
        require(_durationSeconds > 0, "Duration must be greater than 0");

        campaignCount++;

        campaigns[campaignCount] = Campaign({
            creator: payable(msg.sender),
            title: _title,
            goalWei: _goalWei,
            deadline: block.timestamp + _durationSeconds,
            totalRaised: 0,
            finalized: false,
            successful: false
        });
    }

    // Contribute ETH to a campaign
    function contribute(uint256 _campaignId) external payable {
        Campaign storage campaign = campaigns[_campaignId];

        require(block.timestamp < campaign.deadline, "Campaign ended");
        require(msg.value > 0, "Must send ETH");

        campaign.totalRaised += msg.value;
        contributions[_campaignId][msg.sender] += msg.value;

        // Mint reward fan tokens
        uint256 rewardAmount = (msg.value * rewardRate * 1e18) / 1 ether;
        fanToken.mint(msg.sender, rewardAmount);

    }

    // Finalize campaign after deadline
    function finalizeCampaign(uint256 _campaignId) external {
        Campaign storage campaign = campaigns[_campaignId];

        require(block.timestamp >= campaign.deadline, "Campaign still active");
        require(!campaign.finalized, "Already finalized");

        campaign.finalized = true;

        if (campaign.totalRaised >= campaign.goalWei) {
            campaign.successful = true;
        }
    }

    // Withdraw funds (only if successful)
    function withdraw(uint256 _campaignId) external {
        Campaign storage campaign = campaigns[_campaignId];

        require(campaign.finalized, "Not finalized");
        require(campaign.successful, "Campaign failed");
        require(msg.sender == campaign.creator, "Not campaign creator");

        uint256 amount = campaign.totalRaised;
        campaign.totalRaised = 0;

        campaign.creator.transfer(amount);
    }

    // Refund contributors (only if failed)
    function refund(uint256 _campaignId) external {
        Campaign storage campaign = campaigns[_campaignId];

        require(campaign.finalized, "Not finalized");
        require(!campaign.successful, "Campaign successful");

        uint256 contributed = contributions[_campaignId][msg.sender];
        require(contributed > 0, "Nothing to refund");

        contributions[_campaignId][msg.sender] = 0;
        payable(msg.sender).transfer(contributed);
    }

    // Helper function to get campaign info
    function getCampaign(uint256 _campaignId)
        external
        view
        returns (
            address creator,
            string memory title,
            uint256 goalWei,
            uint256 deadline,
            uint256 totalRaised,
            bool finalized,
            bool successful
        )
    {
        Campaign memory c = campaigns[_campaignId];
        return (
            c.creator,
            c.title,
            c.goalWei,
            c.deadline,
            c.totalRaised,
            c.finalized,
            c.successful
        );
    }
}
