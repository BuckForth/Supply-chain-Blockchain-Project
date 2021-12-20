// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

contract ResourceContract {

    struct ResourceTransactor{
        address ownerAddr;       //AssetOwner
        uint bal;                //Cents. No floating point errors here
    }


    struct SaleOffer{
        address ownerAddr;      //AssetOwner
        address listingAddr;    //Listing to off-chain DB entry for goods
        uint ownerActID;        //ActorID of the seller
        uint quantity;          //Number of instances remaining for purchace
        uint listingPrice;      //Cents. No floating point errors here
    }

    struct Waybill{
        address senderAddr;       //AssetOwner
        address receiverAddr;     //AssetCustomer
        address listingAddr;      //Listing to off-chain DB entry for goods
        uint assetID;            //ID of asset being bought
        uint quantity;            //Number of instances remaining for purchace
        uint saleTotal;           //Cents. No floating point errors here
    }

    ResourceTransactor[] public actors;
    SaleOffer[] public sales;
    Waybill[] public waybills;


//Enter the resource market, Assert user enters with at least 5 tokens.
    function joinMarket(uint _bal) public returns (uint _assetID) 
    {
        require(_bal >= 5, "Must have at least 5 tokens");
        actors.push(ResourceTransactor({
                ownerAddr: msg.sender,
                bal: _bal
            }));
        _assetID = (actors.length - 1);
    }

//Add a new listing for an item Note, Since listing database is not included, listing address is instead record as the actor's blockchain address
    function addListing(uint _quantity, uint _listingPrice, uint _actorID) public returns (uint _assetID) 
    {
        sales.push(SaleOffer({
                ownerAddr: msg.sender,
                listingAddr: actors[_actorID].ownerAddr,
                ownerActID: _actorID,
                quantity: _quantity,
                listingPrice: _listingPrice
            }));
            _assetID = (sales.length - 1);
    }

//Look up DB entry by listing ID
    function getListing(uint _assetID) public view returns (SaleOffer memory _sale)
    {
        require(_assetID >= 0, "assetID must be equal or greater then 0");
        require(_assetID < sales.length, "assetID out of range");
        _sale = sales[_assetID];

    }

//Look up listing price by listing ID
    function getPrice(uint _assetID) public view returns (uint _price)
    {
        require(_assetID >= 0, "assetID must be equal or greater then 0");
        require(_assetID < sales.length, "assetID out of range");
        _price = sales[_assetID].listingPrice;
    }

//Look up listing quantity by listing ID
    function getQuantity(uint _assetID) public view returns (uint _quantity)
    {
        require(_assetID >= 0, "assetID must be equal or greater then 0");
        require(_assetID < sales.length, "assetID out of range");
        _quantity = sales[_assetID].quantity;
    }


//Purchase a resource from a supplier
    function purchaseResource(uint _assetID, uint _quantity, uint _consumerID) public returns (uint _waybillID)
    {
        require(_assetID >= 0 && _assetID < sales.length, "itemID out of range");
        SaleOffer storage sale = sales[_assetID];
        require(sale.quantity > 0 && _quantity > 0, "Quantity must be > 0");
        require(sale.quantity >= _quantity, "Seller cannot supply quantity");
        require(sale.ownerActID < actors.length && sale.ownerActID >= 0, "Invalid actorID");
        ResourceTransactor storage seller = actors[sale.ownerActID];
        require(seller.ownerAddr == sale.ownerAddr, "Supplier address mismatch");
        require(actors[_consumerID].ownerAddr == msg.sender, "Consumer address mismatch");
        require(actors[_consumerID].bal >= (sale.listingPrice * _quantity), "Ballance insufficent for transaction");
        //Generate waybill for records
        waybills.push(Waybill({
                senderAddr: sale.ownerAddr,                 //AssetOwner
                receiverAddr: msg.sender,                   //AssetCustomer
                listingAddr: sale.listingAddr,              //Listing to off-chain DB entry for goods
                assetID: _assetID,                          //ID of asset being bought
                quantity: _quantity,                        //Number of instances for purchace
                saleTotal: (sale.listingPrice * _quantity)  //Total cost of items
            }));
        sales[_assetID].quantity = sales[_assetID].quantity - _quantity;
        actors[sale.ownerActID].bal = actors[sale.ownerActID].bal + (sale.listingPrice * _quantity);
        actors[_consumerID].bal = actors[_consumerID].bal - (sale.listingPrice * _quantity);
        _waybillID = (waybills.length - 1);
    }

//Retrieve Waybill
    function retrieveWaybill (uint _waybillID) public view returns (Waybill memory _bill)
    {
        require(_waybillID >= 0 && _waybillID < waybills.length, "Invalid bill ID");
        _bill = waybills[_waybillID];
    }
}