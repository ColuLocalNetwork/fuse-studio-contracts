pragma solidity ^0.4.24;

import 'openzeppelin-solidity/contracts/ownership/Ownable.sol';

contract MembersList is Ownable {
    mapping (address => string) public members;

    event MemberAdded(address indexed account, string memberUri);
    event MemberRemoved(address indexed account);
    event MemberUpdated(address indexed account, string memberUri);

    function addMember(address _account, string _memberUri) onlyOwner public {
        require(_account != address(0));
        require(bytes(members[_account]).length == 0);
        members[_account] = _memberUri;

        emit MemberAdded(_account, _memberUri);
    }

    function removeMember(address _account) onlyOwner public {
        require(_account != address(0));
        require(bytes(members[_account]).length > 0);
        delete members[_account];

        emit MemberRemoved(_account);
    }

    function updateMember(address _account, string _memberUri) onlyOwner public {
        require(_account != address(0));
        require(bytes(members[_account]).length > 0);
        members[_account] = _memberUri;

        emit MemberUpdated(_account, _memberUri);
    }

    function join(string _memberUri) public {
        require(bytes(members[msg.sender]).length == 0);
        members[msg.sender] = _memberUri;

        emit MemberAdded(msg.sender, _memberUri);
    }
}