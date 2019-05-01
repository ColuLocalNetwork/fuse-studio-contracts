pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "./ITransferManager.sol";
import "./EntitiesList.sol";
import "./Rule.sol";

contract EntitiesTransferManager is
    ITransferManager {
  EntitiesList public entitiesList;
  Rule[] private _rules;
  bytes32 public constant userMask = bytes32(1);
  bytes32 public constant adminMask = bytes32(2);
  uint256 public constant maxRules = 20;
  
  event RuleAdded(bytes32 fromMask, bytes32 toMask, bool isMax, uint256 amount);
  event RuleRemoved(uint256 index);

  constructor () public {
    entitiesList = new EntitiesList();
    entitiesList.addEntity(msg.sender, '', userMask | adminMask);
  }

  modifier onlyAdmin () {
    require(entitiesList.hasPermission(msg.sender, adminMask));
    _;
  }


  /**
   * @dev Whitelist type transfer logic, Should be pluggable in the future.
   * @param _from The address to transfer from.
   * @param _to The address to transfer to.
   * @param _value The address to transfer to.
   */
  function verifyTransfer(address _from, address _to, uint256 _value) public view returns (bool) {
    bytes32 fromPermissions = entitiesList.permissionsOf(_from);
    bytes32 toPermissions = entitiesList.permissionsOf(_to);

    if (_rules.length == 0) {
      return true;
    }

    for (uint i = 0; i < _rules.length; i++) {
      Rule rule = _rules[i];
      if (rule.verify(fromPermissions, toPermissions, _value)) {
        return true;
      }
    }
    return false;
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

  function addRule(bytes32 _fromMask, bytes32 _toMask) public onlyAdmin {
    require(_rules.length < maxRules);
    Rule rule = new Rule(_fromMask, _toMask, false, 0);
    _rules.push(rule);

    emit RuleAdded(_fromMask, _toMask, false, 0);
  }

  function addRule(bytes32 _fromMask, bytes32 _toMask, bool _isMax, uint256 _amount) public onlyAdmin {
    require(_rules.length < maxRules);
    Rule rule = new Rule(_fromMask, _toMask, _isMax, _amount);
    _rules.push(rule);

    emit RuleAdded(_fromMask, _toMask, _isMax, _amount);
  }

  function removeRule(uint256 _index) public onlyAdmin {
    require(_index < _rules.length);

    for (uint i = _index; i < _rules.length-1; i++) {
      _rules[i] = _rules[i+1];
    }
    _rules.length--;

    emit RuleRemoved(_index);
  }

}
