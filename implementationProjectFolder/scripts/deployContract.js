async function main(){
    const ResourceContract = await ethers.getContractFactory("ResourceContract");
    const resourceContract = await ResourceContract.deploy();

    console.log("Supply-chain blockchain APP deployed to:", resourceContract.address);
}

main()
.then(() => process.exit(0))
.catch(error => {
    console.error(error);
    process.exit(1);
});