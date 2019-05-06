pragma solidity ^0.5.0;

library Entities {
    struct Entity {
        mapping (address => bytes) bearer;
    }

    function add(Entity storage entity, address _account, bytes _roles) internal {
        require(!has(entity, _account));
        entity.bearer[_account] = _roles;
    }

    function update(Entity storage entity, address _account, bytes _roles) internal {
        require(has(entity, _account));
        entity.bearer[_account] = _roles;
    }

    function remove(Entity storage entity, address _account, bytes _roles) internal {
        require(has(entity, _account));
        delete entity.bearer[_account]
    }

    function addRoles(Entity storage entity, address _account, bytes _roles) internal {
        require(has(entity, _account));
        entity.bearer[_account] = entity.bearer[_account] | _roles;
    }

    function removeRoles(Entity storage entity, address _account, bytes _roles) internal {
        require(has(entity, _account));
        entity.bearer[_account] = entity.bearer[_account] & (_roles ^ bytes(32));
    }

    function has(Entity storage role, address account) internal view returns (bool) {
        require(account != address(0));
        return role.bearer[account];
    }

    function hasRoles(Entity storage entity, address _account, bytes _roles) internal view returns (bool) {
        require(_account != address(0));
        return (entity.bearer[_account] & _roles) == _roles;
    }
}