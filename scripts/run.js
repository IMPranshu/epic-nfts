
const main = async () => {
    const nftContractFactory = await hre.ethers.getContractFactory('MyEpicNFT');
    const nftContract = await nftContractFactory.deploy();
    await nftContract.deployed();
    console.log("Note the address for here:", nftContract.address);

    // call the func
let txn = await nftContract.makeAnEpicNFT()
// wait for it to be minted
await txn.wait()


// Mint another NFT for fun
txn = await nftContract.makeAnEpicNFT()
await txn.wait()
};


const runMain = async() => {
    try {
        await main();
        process.exit(0);
    } catch (error) {
        console.log(error);
        process.exit(1);
    }
};

runMain();