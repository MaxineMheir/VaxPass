//Contract based on https://docs.openzeppelin.com/contracts/3.x/erc721
// SPDX-License-Identifier: MIT
pragma solidity ^0.7.3;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyNFT is ERC721, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // Mapping from token ID to owner address
    mapping(uint256 => address) private _ownersTEMP;

    constructor() public ERC721("MyNFT", "NFT") {}

    /// @notice Returns a list of all Kitty IDs assigned to an address.
    /// @param _owner The owner whose Kitties we are interested in.
    /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
    ///  expensive (it walks the entire Kitty array looking for cats belonging to owner),
    ///  but it also returns a dynamic array, which is only supported for web3 calls, and
    ///  not contract-to-contract calls.
    function tokensOfOwner(address _owner) external view returns(string[] memory) {
        uint256 tokenCount = balanceOf(_owner);

        if (tokenCount == 0) {
            // Return an empty array
            return new string[](0);
        } else {
            string[] memory result = new string[](tokenCount);
            uint256 totalVaccines = _tokenIds.current();
            uint256 resultIndex = 0;

            // We count on the fact that all vaccines have IDs starting at 1 and increasing
            // sequentially up to the totalVaccine count.
            uint256 vaccineId;
            for (vaccineId = 1; vaccineId <= totalVaccines; vaccineId++) {
                if (_ownersTEMP[vaccineId] == _owner) {
                    result[resultIndex] = tokenURI(vaccineId);
                    resultIndex++;
                }
            }
            
            return result;
        }
    }

    function mintNFT(address recipient, string memory tokenURI) public onlyOwner returns (uint256) {
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();

        _ownersTEMP[newItemId] = recipient;
        _mint(recipient, newItemId); // user_id_address -> nft_id
        _setTokenURI(newItemId, tokenURI); //nft_id -> metadata

        return newItemId;
    }
}