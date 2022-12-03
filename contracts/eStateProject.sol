// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/math/SafeMathUpgradeable.sol";

import "./ereitToken.sol";
import "./addressPool.sol";

contract eStateProject {
    using SafeMathUpgradeable for uint256;

    address public builder;

    struct ProjectDetail {
        string start_date;
        string end_date;
        uint256 valuation; // in rupee for now
        string prospectus_url;
        string[] lat_log;
        address corporation;
    }

    struct InvestorDetail {
        address investor;
        uint256 amount;
    }

    uint256 public totalInvestor = 1; // id's will be 1 onwards
    mapping(uint256 => InvestorDetail) public investor_detail;
    mapping(address => uint256) public mpid;
    mapping(uint256 => mapping(address => uint256)) mpctoaa;

    EREIT ereit;
    address ereitAddress;
    ProjectDetail public projectDetail;

    uint256 cycle = 1;
    mapping(uint256 => uint256) public total_invested_amounts;
    mapping(address => uint256) collectedTill;

    constructor(
        address _addressPool,
        address _builder,
        ProjectDetail memory _projectDetails
    ) {
        /*
            require only called from builder contract
        */
        require(
            AddressPool(_addressPool).getBuilderAddress() == msg.sender,
            "not authorized"
        );
        builder = _builder;
        ereitAddress = AddressPool(_addressPool).getEreitTokenAddress();
        ereit = EREIT(ereitAddress);
        projectDetail = _projectDetails;
    }

    /* 
        Modifier to check token allowance
    */
    modifier checkAllowance(uint256 amount) {
        require(ereit.allowance(msg.sender, address(this)) >= amount, "Error");
        _;
    }

    /*
        inital investor will be able to invest this project
    */
    function invest(uint256 _amount) public checkAllowance(_amount) {
        if (mpid[msg.sender] == 0) {
            // if didn't fund before
            InvestorDetail storage newID = investor_detail[totalInvestor++];
            newID.investor = msg.sender;
            mpid[msg.sender] = totalInvestor - 1;
            IERC20Upgradeable(ereitAddress).transferFrom(
                msg.sender,
                address(this),
                _amount
            );
            newID.amount = _amount; // current to eriet
            total_invested_amounts[cycle] += _amount;
            mpctoaa[cycle][msg.sender] = _amount;
        } else {
            IERC20Upgradeable(ereitAddress).transferFrom(
                msg.sender,
                address(this),
                _amount
            );
            investor_detail[mpid[msg.sender]].amount += _amount;
            total_invested_amounts[cycle] += _amount;
            mpctoaa[cycle][msg.sender] += _amount;
        }
    }

    /* 
        withdraw your fund by some investment or all
    */
    function withdrawInvestment(uint256 _amount) public {
        require(
            investor_detail[mpid[msg.sender]].amount >= _amount,
            "funded amount too low"
        );
        total_invested_amounts[cycle] -= _amount;
        mpctoaa[cycle][msg.sender] -= _amount;
        if (investor_detail[mpid[msg.sender]].amount == _amount) {
            investor_detail[mpid[msg.sender]] = investor_detail[
                totalInvestor - 1
            ];
            delete investor_detail[totalInvestor - 1];
            delete mpid[msg.sender];
            totalInvestor -= 1;
        } else {
            investor_detail[mpid[msg.sender]].amount -= _amount;
        }
        IERC20Upgradeable(ereitAddress).transfer(address(this), _amount);
    }

    /*
        get investor of this project
    */

    function getAllInvestor() public view returns (InvestorDetail[] memory) {
        InvestorDetail[] memory allInvestor = new InvestorDetail[](
            totalInvestor - 1
        );
        for (uint256 i = 1; i <= totalInvestor; i++) {
            allInvestor[i - 1] = investor_detail[i];
        }
        return allInvestor;
    }

    /*
        take collected rent from tenant,
        @future will verify audited document for that corparate building
        msg.sender first have to approve this contract to withdraw _amount
    */
    function payRent(uint256 _amount) public checkAllowance(_amount) {
        require(
            msg.sender == projectDetail.corporation,
            "should be paid by managing corporation"
        );
        cycle += 1;
        IERC20Upgradeable(ereitAddress).transferFrom(
            msg.sender,
            address(this),
            _amount
        );
    }

    /*
        claim rent collected from tenant
    */
    function claimRentRewards() public {
        require(collectedTill[msg.sender] < cycle, "you already clamined");
        uint256 claimedRewards = 0;
        for (
            uint256 _cycle = collectedTill[msg.sender] + 1;
            _cycle < cycle;
            _cycle++
        ) {
            (bool success, uint256 result) = mpctoaa[_cycle][msg.sender].tryDiv(
                total_invested_amounts[_cycle]
            );
            require(success, "division of rent failed");
            claimedRewards += result;
        }
        collectedTill[msg.sender] = cycle - 1;
        require(
            IERC20Upgradeable(ereitAddress).transfer(msg.sender, claimedRewards)
        );
    }

    function getInvestedAmountInCycle(address account, uint256 _cycle)
        public
        view
        returns (uint256)
    {
        return mpctoaa[_cycle][account];
    }
}
