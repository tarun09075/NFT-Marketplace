// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract SimpleNFTMarketplace is ERC721 {
    uint256 public tokenCounter;
    address payable public owner;

    struct Listing {
        address seller;
        uint256 price;
        bool active;
    }

    mapping(uint256 => Listing) public listings;
    mapping(address => uint256) public pendingWithdrawals;

    constructor() ERC721("SimpleNFTMarketplace", "SNFT") {
        tokenCounter = 1;
        owner = payable(msg.sender);
    }

    // 1. Mint a new NFT to the caller
    function mintNFT() external {
        _safeMint(msg.sender, tokenCounter);
        tokenCounter++;
    }

    // 2. List NFT for sale
    function listNFT(uint256 tokenId, uint256 price) external {
        require(ownerOf(tokenId) == msg.sender, "Not NFT owner");
        require(price > 0, "Price must be positive");
        listings[tokenId] = Listing(msg.sender, price, true);
    }

    // 3. Buy a listed NFT
    function buyNFT(uint256 tokenId) external payable {
        Listing memory listing = listings[tokenId];
        require(listing.active, "NFT not listed");
        require(msg.value >= listing.price, "Insufficient payment");

        listings[tokenId].active = false;
        pendingWithdrawals[listing.seller] += msg.value;

        _transfer(listing.seller, msg.sender, tokenId);
    }

    // 4. Withdraw funds earned from sales
    function withdraw() external {
        uint256 amount = pendingWithdrawals[msg.sender];
        require(amount > 0, "No funds to withdraw");
        pendingWithdrawals[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }
}
