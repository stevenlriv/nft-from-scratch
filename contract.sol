// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Royalty.sol";

contract LotsOfLaugh is ERC721, ERC721Enumerable, ERC721Royalty, Ownable {

    /**
     * Token
     */
    uint256 public constant MAX_SUPPLY = 3;

    constructor() ERC721("LotsOfLaugh", "LOL") {
    }

    /**
     * Mint
     */
    bool public saleIsActive = false;

    function setSaleState(bool newState) public onlyOwner {
        saleIsActive = newState;
    }

    function mint(uint numberOfTokens) public payable {
        uint256 ts = totalSupply();
        require(saleIsActive, "Sale must be active to mint tokens");
        require(numberOfTokens <= MAX_PUBLIC_MINT, "Exceeded max token purchase");
        require(ts + numberOfTokens <= MAX_SUPPLY, "Purchase would exceed max tokens");
        require(PRICE_PER_TOKEN * numberOfTokens <= msg.value, "Ether value sent is not correct");

        for (uint256 i = 0; i < numberOfTokens; i++) {
            _safeMint(msg.sender, ts + i);
        }
    }

    /**
     * Utils
     */
    uint256 public MAX_PUBLIC_MINT;
    uint256 public PRICE_PER_TOKEN;

    string public PROVENANCE;
    string private _baseURIextended;

    address public royaltyAddress;
    uint96 public royaltyBps;
    
    function reserve(uint numberOfTokens) public onlyOwner {
      uint256 ts = totalSupply();
      uint i;

      require(ts + numberOfTokens <= MAX_SUPPLY, "Reserve amount would exceed max tokens");
      for (i = 0; i < numberOfTokens; i++) {
          _safeMint(msg.sender, ts + i);
      }
    }

    function withdraw() public onlyOwner {
        uint balance = address(this).balance;
        payable(msg.sender).transfer(balance);
    }

    function setMaxPublicMint(uint256 maxPublicMint) public onlyOwner {
        MAX_PUBLIC_MINT = maxPublicMint;
    }

    function setPricePerToken(uint256 pricePerToken) public onlyOwner {
        PRICE_PER_TOKEN = pricePerToken;
    }

    function setProvenance(string memory provenance) public onlyOwner {
        PROVENANCE = provenance;
    }

    function setBaseURI(string memory baseURI_) external onlyOwner() {
        _baseURIextended = baseURI_;
    }

    function setDefaultRoyalty(address _receiver, uint96 _feeNumerator) public onlyOwner {
        royaltyAddress = _receiver;
        royaltyBps = _feeNumerator;
        
        _setDefaultRoyalty(royaltyAddress, royaltyBps);
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseURIextended;
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC721Royalty, ERC721Enumerable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721Royalty) {
        super._burn(tokenId);
    }
}