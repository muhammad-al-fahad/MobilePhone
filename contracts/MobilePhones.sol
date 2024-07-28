// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract MobilePhones {
    enum Status {
        notCreated,
        available,
        selled
    }
    struct Phone {
        string model_Number;
        string imei1;
        string imei2;
        address owner;
        Status status;
    }

    mapping(string => Phone) PhoneOwners;

    address ownerAddress;

    event ADDPHONE(string _model_Number, string _imei1, string _imei2);
    event TRANSFERPHONE(address from, address to, string _imei);

    constructor() {
        ownerAddress = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == ownerAddress, "You are not allowed to add phone");
        _;
    }

    modifier phoneExists(string memory _imei) {
        require(
            PhoneOwners[_imei].status != Status.notCreated,
            "No phone exists at this IMEI Number"
        );
        _;
    }

    modifier onlyPhoneOwner(string memory _imei) {
        require(
            (PhoneOwners[_imei].status != Status.notCreated &&
                (PhoneOwners[_imei].owner == msg.sender ||
                    ownerAddress == msg.sender)),
            "Only the phone owner can do this"
        );
        _;
    }

    function addPhone(
        string memory _model_Number,
        string memory _imei1,
        string memory _imei2
    ) external onlyOwner returns (bool) {
        require(
            PhoneOwners[_imei1].status == Status.notCreated,
            "Mobile Phone at this imei already exists"
        );

        PhoneOwners[_imei1] = Phone(
            _model_Number,
            _imei1,
            _imei2,
            0x0000000000000000000000000000000000000000,
            Status.available
        );

        emit ADDPHONE(_model_Number, _imei1, _imei2);

        return true;
    }

    function getPhoneDetails(string memory _imei)
        external
        view
        returns (
            string memory,
            string memory,
            string memory,
            address,
            Status
        )
    {
        return (
            PhoneOwners[_imei].model_Number,
            PhoneOwners[_imei].imei1,
            PhoneOwners[_imei].imei2,
            PhoneOwners[_imei].owner,
            PhoneOwners[_imei].status
        );
    }

    function transfer(string memory _imei, address to)
        external
        onlyPhoneOwner(_imei)
        phoneExists(_imei)
        returns (bool)
    {
        PhoneOwners[_imei].owner = to;
        PhoneOwners[_imei].status = Status.selled;
        emit TRANSFERPHONE(msg.sender, to, _imei);
        return true;
    }
}