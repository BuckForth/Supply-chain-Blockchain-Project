const { expect } = require("chai");

describe("ResourceContract", () => {
  it("Can deploy a market(ResourceContract) and post an item listing", async () => {
    const ResourceContract = await ethers.getContractFactory("ResourceContract");
    const resourceContract = await ResourceContract.deploy();
    await resourceContract.deployed();
    expect(await resourceContract.joinMarket(1000) == 0);
    expect(await resourceContract.joinMarket(2000) == 1);
    expect(await resourceContract.joinMarket(4000) == 2);
    expect(await resourceContract.joinMarket(8000) == 3);
    expect(await resourceContract.addListing(45, 150, 0) == 0);
    expect(await resourceContract.addListing(50, 200, 1) == 1);
    expect(await resourceContract.addListing(15, 100, 2) == 2);
    expect(await resourceContract.addListing(30, 5, 3) == 3);
  });

  it("Can find an item's details", async () => {
    const ResourceContract = await ethers.getContractFactory("ResourceContract");
    const resourceContract = await ResourceContract.deploy();
    await resourceContract.deployed();
    expect(await resourceContract.joinMarket(1000) == 0);
    expect(await resourceContract.addListing(45, 150, 0) == 0);
    expect(await resourceContract.getPrice(0) == 150);
    expect(await resourceContract.getQuantity(0) == 45);
  });

  it("Can find an item's listing", async () => {
    const ResourceContract = await ethers.getContractFactory("ResourceContract");
    const resourceContract = await ResourceContract.deploy();
    await resourceContract.deployed();
    expect(await resourceContract.joinMarket(1000) == 0);
    expect(await resourceContract.addListing(45, 150, 0) == 0);
    var listing1 = await resourceContract.getListing(0);
  });

  it("Can purchase an item's by marketID", async () => {
    const ResourceContract = await ethers.getContractFactory("ResourceContract");
    const resourceContract = await ResourceContract.deploy();
    await resourceContract.deployed();
    expect(await resourceContract.joinMarket(1000) == 0);
    expect(await resourceContract.joinMarket(1000) == 1);
    expect(await resourceContract.addListing(45, 150, 0) == 0);

    expect(await resourceContract.purchaseResource(0, 5, 1) == 0);
  });

  it("Can retrieve an item's waybill by billID", async () => {
    const ResourceContract = await ethers.getContractFactory("ResourceContract");
    const resourceContract = await ResourceContract.deploy();
    await resourceContract.deployed();
    expect(await resourceContract.joinMarket(10000) == 0);
    expect(await resourceContract.joinMarket(10000) == 1);
    expect(await resourceContract.addListing(50, 100, 0) == 0);
    expect(await resourceContract.addListing(50, 100, 0) == 1);
    expect(await resourceContract.addListing(50, 100, 0) == 2);

    expect(await resourceContract.addListing(50, 100, 1) == 3);
    expect(await resourceContract.addListing(50, 100, 1) == 4);
    expect(await resourceContract.addListing(50, 100, 1) == 5);
    
    expect(await resourceContract.purchaseResource(0, 5, 1) == 0);
    expect(await resourceContract.purchaseResource(1, 5, 1) == 1);
    expect(await resourceContract.purchaseResource(3, 5, 0) == 2);
    expect(await resourceContract.purchaseResource(5, 5, 0) == 3);

    var bill1 = await resourceContract.retrieveWaybill(0);
    var bill2 = await resourceContract.retrieveWaybill(1);
    var bill3 = await resourceContract.retrieveWaybill(2);
    var bill4 = await resourceContract.retrieveWaybill(3);
  });

});