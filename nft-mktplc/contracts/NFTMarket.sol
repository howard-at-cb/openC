// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract NFTMarket is ReentrancyGuard {
    using Counters for Counters.Counter;

    Counters.Counter private _itemIds;
    Counters.Counter private _itemsSold;

    address payable owner;
    uint256 listingPrice = 0.025 ether; // actually MATIC for Polygon chain

    constructor() {
        owner = payable(msg.sender);
    }

    struct MarketItem {
        uint itemId;
        address nftContract;
        uint256 tokenId;
        address payable seller;
        address payable owner;
        uint256 price;
        bool sold;
    }

    mapping(uint256 => MarketItem) private idToMarketItem;

    event MarketItemCreated (
        uint indexed itemId,
        address indexed nftContract,
        uint256 indexed tokenId,
        address seller,
        address owner,
        uint256 price,
        bool sold
    );

    function getListingPrice() public view returns(uint256) {
        return listingPrice;
    }

    function createMarketItem(address nftContract, uint256 tokenId, uint256 price) public payable nonReentrant {
        require (price > 0, "Price must be at least one wei");
        require(msg.value == listingPrice, "value sent for listing tx must be equal to listing price");

        _itemIds.increment();
        uint256 itemId = _itemIds.current();

        idToMarketItem[itemId] = MarketItem(
            itemId,
            nftContract,
            tokenId,
            payable(msg.sender),
            payable(address(0)), // owner set as empty address for now, as no owner at the moment prior to sale
            price,
            false
        );

        // https://docs.openzeppelin.com/contracts/4.x/api/token/erc721#IERC721-safeTransferFrom-address-address-uint256-
        IERC721(nftContract).transferFrom(msg.sender, address(this), tokenId);

        emit MarketItemCreated(
            itemId,
            nftContract,
            tokenId,
            msg.sender,
            address(0),
            price,
            false
        );
    }

    function createMarketSale(address nftContract, uint256 itemId) public payable nonReentrant {
        uint price = idToMarketItem[itemId].price;
        uint tokenId = idToMarketItem[itemId].tokenId;

        // gas fee is not part of msg.value, but it is required for a tx to go through 
        require(msg.value == price, "please submit the asking price in order to complete the purchase");

        idToMarketItem[itemId].seller.transfer(msg.value);
        IERC721(nftContract).transferFrom(address(this), msg.sender, tokenId); // transferring ownership of NFT to buyer

        idToMarketItem[itemId].owner = payable(msg.sender);
        idToMarketItem[itemId].sold = true;

        _itemsSold.increment();
        payable(owner).transfer(listingPrice); // listing price transferred to the person running this mktplc
    }

    // fetch all unsold items in the marketplace, for front end display
    function fetchMarketItems() public view returns (MarketItem[] memory) {
        uint itemCount = _itemIds.current();
        uint unsoldItemCount = _itemIds.current() - _itemsSold.current();
        uint currentIndexForUnsoldItems = 0;

        MarketItem[] memory unsoldItems = new MarketItem[](unsoldItemCount);

        // idToMarketItem is a map, whose key is a Counter, and starts from one (initially we first did increment, then insert)
        for (uint i = 1; i <= itemCount; i++) {
            if (idToMarketItem[i].owner == address(0)) { // unsold items are owned by empty address (to begin with)
                unsoldItems[currentIndexForUnsoldItems] = idToMarketItem[i]; // vid timestamp 51:30 (TODO: verify)
                currentIndexForUnsoldItems += 1;
            }
        }
        return unsoldItems;
    }

    // fetch all NFTs purchased by msg.sender (for profile view)
    function fetchNFTsBought() public view returns (MarketItem[] memory) {
        uint totalItemCount = _itemIds.current();
        uint itemBoughtCount = 0;
        uint currentIndex = 0;

        for (uint i = 1; i <= totalItemCount; i ++) {
            if (idToMarketItem[i].owner == msg.sender) {
                itemBoughtCount += 1;
            }
        }
        
        // Dynamic arrays are only available in storage, not in memory.
        MarketItem [] memory boughtItems = new MarketItem[](itemBoughtCount);
        for (uint i = 1; i <= totalItemCount; i ++) {
            if (idToMarketItem[i].owner == msg.sender) {
                boughtItems[currentIndex] = idToMarketItem[i];
                currentIndex += 1;
            }
        }

        return boughtItems;
    }

    // fetch all NFTs created/listed by msg.sender
    function fetchNFTsListed() public view returns (MarketItem[] memory) {
        uint totalItemCount = _itemIds.current();
        uint itemListedCount = 0;
        uint currentIndex = 0;

        for (uint i = 1; i <= totalItemCount; i ++) {
            if (idToMarketItem[i].seller == msg.sender) {
                itemListedCount += 1;
            }
        }

        MarketItem[] memory listedItems = new MarketItem[](itemListedCount);
        for (uint i = 1; i <= totalItemCount; i++) {
            if (idToMarketItem[i].seller == msg.sender) {
                listedItems[currentIndex] = idToMarketItem[i];
                currentIndex += 1;
            }
        }
        return listedItems;
    }
}