// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./eStateProject.sol";

contract Builder {
    uint256 public builder_cnt = 1;
    struct builder {
        string name;
        string gstno;
        string brochure_url;
        address[] projects;
    }
    mapping(uint256 => builder) public buildermp;
    mapping(address => uint256) public addressmp;
    address addressPool;

    constructor(address _addressPool) {
        addressPool = _addressPool;
    }

    function addBuilder(
        string memory _name,
        string memory _gstno,
        string memory _brochure_url
    ) public {
        require(addressmp[msg.sender] == 0, "builder already exist");
        builder storage new_builder = buildermp[builder_cnt++];
        new_builder.name = _name;
        new_builder.gstno = _gstno;
        new_builder.brochure_url = _brochure_url;
        addressmp[msg.sender] = builder_cnt - 1;
    }

    function createProject(eStateProject.ProjectDetail memory pd) public {
        require(addressmp[msg.sender] != 0, "builder not exist");
        eStateProject newEStateProject = new eStateProject(
            addressPool,
            msg.sender,
            pd
        );

        buildermp[addressmp[msg.sender]].projects.push(
            address(newEStateProject)
        );
    }

    function getAllProjects(address _address)
        public
        view
        returns (address[] memory)
    {
        return buildermp[addressmp[_address]].projects;
    }
}
