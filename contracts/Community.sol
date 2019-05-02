pragma solidity ^0.4.24;

import "./EntitiesList.sol";


contract Community {
    EntitiesList public entitiesList;
    bytes32 public constant userMask = bytes32(1);
    bytes32 public constant adminMask = bytes32(2);

    constructor () public {
        entitiesList = new EntitiesList();
        entitiesList.addEntity(msg.sender, '', userMask | adminMask);
    }

    modifier onlyAdmin () {
        require(entitiesList.hasPermission(msg.sender, adminMask));
        _;
    }

    function join(string _entityUri) public {
        entitiesList.addEntity(msg.sender, _entityUri, userMask);
    }

    function addEntity(address _account, string _entityUri, bytes32 _permissions) public onlyAdmin {
        entitiesList.addEntity(_account, _entityUri, _permissions);
    }

    function updateEntityUri(address _account, string _entityUri) public onlyAdmin {
        entitiesList.updateEntityUri(_account, _entityUri);
    }

    function updateEntityPermissions(address _account, bytes32 _entityPermissions) public onlyAdmin {
        entitiesList.updateEntityPermissions(_account, _entityPermissions);
    }

    function removeEntity(address _account) onlyAdmin public {
        entitiesList.removeEntity(_account);
    }
}