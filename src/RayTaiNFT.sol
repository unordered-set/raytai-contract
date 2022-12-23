// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "solmate/auth/Owned.sol";
import "solmate/tokens/ERC721.sol";
import "solmate/utils/LibString.sol";
import "solmate/utils/MerkleProofLib.sol";

contract RayTaiNFT is ERC721, Owned {
    bytes32 immutable public _root;
    uint256 immutable public _allowlist_price;
    uint256 immutable public _public_price;
    uint8 immutable public _allowlist_per_acc_limit;
    uint8 immutable public _public_per_acc_limit;
    uint16 immutable public _total_limit;

    uint16 _counter;
    string _baseURI;

    struct MintCounters {
        uint8 minted_from_allow_list;
        uint8 minted_from_public_sale;
    }
    mapping(address => MintCounters) _per_acc_counters;

    constructor(string memory name, string memory symbol, bytes32 merkleroot,
                uint256 allowlist_price, uint256 public_price,
                uint8 allowlist_per_acc_limit, uint8 public_per_acc_limit,
                uint16 total_limit)
    ERC721(name, symbol)
    Owned(msg.sender)
    {
        _root = merkleroot;
        _allowlist_price = allowlist_price;
        _public_price = public_price;
        _allowlist_per_acc_limit = allowlist_per_acc_limit;
        _public_per_acc_limit = public_per_acc_limit;
        _total_limit = total_limit;
    }

    function mint(address account, bytes32[] calldata proof)
    external payable
    {
        require(_counter < _total_limit, "No NFTs left");
        require(_verify(_leaf(account), proof), "Invalid merkle proof");
        if (al_mint_in_progress()) {
            require(msg.value == _allowlist_price, "Insufficient ETH provided for AL sale");
            require(_per_acc_counters[account].minted_from_allow_list < _allowlist_per_acc_limit, "Over the AL limit");
            unchecked {
                ++_per_acc_counters[account].minted_from_allow_list;
            }
        } else {
            require(msg.value == _public_price, "Insufficient ETH provided for Public sale");
            require(_per_acc_counters[account].minted_from_public_sale < _public_per_acc_limit, "Over the Public limit");
            unchecked {
                ++_per_acc_counters[account].minted_from_public_sale;
            }
        }
        _mint(account, _counter);
        unchecked {
            ++_counter;
        }
    }

    function al_mint_in_progress() internal view returns (bool) {
        return block.number < 120;
    }

    function _leaf(address account)
    internal pure returns (bytes32)
    {
        return keccak256(abi.encodePacked(account));
    }

    function _verify(bytes32 leaf, bytes32[] calldata proof)
    internal view returns (bool)
    {
        return MerkleProofLib.verify(proof, _root, leaf);
    }

    function tokenURI(uint256 id) public view override returns (string memory) {
        return string(abi.encodePacked(_baseURI, LibString.toString(id)));
    }

    function setBaseURL(string calldata newBaseURI) external onlyOwner {
        _baseURI = newBaseURI;
    }
}