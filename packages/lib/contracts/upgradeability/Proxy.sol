pragma solidity ^0.4.21;

/**
 * @title Proxy
 * @dev Gives the possibility to delegate any call to a foreign implementation.
 */
contract Proxy {
  /**
   * @dev Tells the address of the implementation where every call will be delegated.
   * @return address of the implementation to which it will be delegated
   */
  function implementation() public view returns (address);

  /**
   * @dev Fallback function allowing to perform a delegatecall to the given implementation.
   * This function will return whatever the implementation call returns
   */
  function () payable public {
    address _impl = implementation();

    assembly {
      // 0x40 contains the value for the next available free memory pointer.
      let ptr := mload(0x40)
      // Copy msg.data.
      calldatacopy(ptr, 0, calldatasize)
      // Call the implementation.
      // out and outsize are 0 because we don't know the size yet.
      let result := delegatecall(gas, _impl, ptr, calldatasize, 0, 0)
      // Copy the returned data.
      returndatacopy(ptr, 0, returndatasize)

      switch result
      // delegatecall returns 0 on error.
      case 0 { revert(ptr, returndatasize) }
      default { return(ptr, returndatasize) }
    }
  }
}