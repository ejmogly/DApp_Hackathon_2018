pragma solidity ^0.4.21; // tells the compiler which version of solidity we're using

contract Identification {
    // structs: custom type, groups variables
    struct idInfo {
        string faceID;
        string fingerID;
    }

    // mappings: kind of like a hash table, with keys and values
    mapping (address => idInfo) public idInfos; // `public` automatically creates a getter function 
    address public government;

    // events: interface for EVM logs (historical record)
    event NewidInfo(address _address, string _faceID, string _fingerID);

    // modifiers: semantic helper functions
    modifier onlyOwner {
        require(msg.sender == government); // conditional requirement check
        _; // function gets amended here
    }

    // constructor: optional function, executed on contract creation
    constructor() public {
        government = msg.sender;
    }

    function insertIdInfo(address _address, string _faceID, string _fingerID) public onlyOwner {
        idInfos[_address].faceID = _faceID;
        idInfos[_address].fingerID = _fingerID;
        // emit an Event, which stores the values in EVM logs
        emit NewidInfo(_address, _faceID, _fingerID);
    }

    function checkIDs(address _address, string _faceID, string _fingerID) public view onlyOwner payable returns (bool) {
        if ((_address != address(0)) && (keccak256(idInfos[_address].faceID) == keccak256(_faceID)) && (keccak256(idInfos[_address].fingerID) == keccak256(_fingerID))) {
            _address.transfer(msg.value);
            return true;
        }
        else {
            return false;
        }
    }

    function collectDeposit(address _address) payable {
        _address.transfer(msg.value);
    }

}