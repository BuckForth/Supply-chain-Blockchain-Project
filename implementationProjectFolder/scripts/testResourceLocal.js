async function main(){
    const ResourceContract = await ethers.getContractFactory("ResourceContract");
    const resourceContract = await ResourceContract.deploy();
    await resourceContract.deployed();
    await resourceContract.joinMarket(1000);
    await resourceContract.joinMarket(2000);
    await resourceContract.joinMarket(4000);
    await resourceContract.joinMarket(8000);

    await resourceContract.addListing(45, 150, 0);
    await resourceContract.addListing(50, 200, 1);
    await resourceContract.addListing(15, 100, 2);
    await resourceContract.addListing(30, 5, 3);

    await resourceContract.purchaseResource(0, 5, 1);
    await resourceContract.purchaseResource(1, 5, 0);
    await resourceContract.purchaseResource(2, 5, 3);
    await resourceContract.purchaseResource(3, 5, 2);


    console.log("Supply-chain market deployed to:", resourceContract.address);

    for (let ii = 0; ii < resourceContract.waybills.length; ii++)
    {
        var bill = resourceContract.waybills[ii];
        var billString = "[Waybill,\n"
        for (let variable in bill)
        {
            billString += variable + " : \t" + bill[variable] + "\n";
        }
        billString +="]"
        console.log(billString);
    }
}

main()
.then(() => process.exit(0))
.catch(error => {
    console.error(error);
    process.exit(1);
});