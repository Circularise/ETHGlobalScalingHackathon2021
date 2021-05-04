pragma solidity >=0.6.0 <0.9.0;
//SPDX-License-Identifier: MIT

import "hardhat/console.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";


contract YourContract is AccessControl, ERC1155 {
  bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
  bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");

  uint256 public current_id;

  event MintedToken(address owner, uint256 id, uint256 amount);
  event BurnedToken(address owner, uint256 id, uint256 amount);

  constructor() public ERC1155("https://example.com/{id}") {
    // what should we do on deploy?
    _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
    _setupRole(MINTER_ROLE, _msgSender());
    _setupRole(PAUSER_ROLE, _msgSender());
  }

  struct Token {
      address creator;
      uint256 id;
  }

  mapping (uint256 => Token) public tokenList;


  function mintToken(address owner, uint256 amount) public virtual returns(uint256) {
      // require(hasRole(MINTER_ROLE, _msgSender()), "ERC1155PresetMinterPauser: must have minter role to mint");

      tokenList[current_id] = Token(owner, current_id);
      _mint(owner, current_id, amount, "");
      emit MintedToken(owner, current_id, amount);

      
      current_id += 1;
      return current_id - 1;
  }

  function burnToken(address owner, uint256 id, uint256 amount) public virtual {

    _burn(owner, id, amount);
    emit BurnedToken(owner, id, amount);

  }

}
