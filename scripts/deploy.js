
const hre = require("hardhat");

const LFGCollectionABI=require("../artifacts/contracts/core/LFGCollection.sol/LFGCollection.json");
const GovernanceABI=require("../artifacts/contracts/core/Governance.sol/Governance.json");
const LFGFactoryABI=require("../artifacts/contracts/core/LFGFactory.sol/LFGFactory.json");

// Governance Address: 0xA311f7BC2e77D0DFe674ebc3c52FBd00b7A161f6
// LFGFactory Address: 0xf8647166A533536815AB00341Fe0f192bA95C503
// Collection 0 Address: 0x6CBEaAF858eEe65F5790e8BCe86Ad3E09b628dBE
// Collection 0 的Token0 : 0x130d773cF16D30f5b2fDb8A417150c22709D0062
async function main() {
    const [owner, manager] = await hre.ethers.getSigners();
    console.log("owner:",owner.address);
    console.log("manager:",manager.address);

    const provider = ethers.provider;
    const network = await provider.getNetwork();
    const chainId = network.chainId;
    console.log("Chain ID:", chainId);

    async function sendETH(toAddress, amountInEther) {
        const amountInWei = ethers.parseEther(amountInEther);
        const tx = {
            to: toAddress,
            value: amountInWei,
        };
        const transactionResponse = await owner.sendTransaction(tx);
        await transactionResponse.wait();
        console.log("Transfer eth success");
    }

    const fee = 100000n;
    const governance =await hre.ethers.getContractFactory("Governance");
    const Governance = await governance.deploy(
        owner.address,
        manager.address,
        manager.address,
        fee
    );
    const GovernanceAddress = Governance.target;
    console.log("Governance Address:",GovernanceAddress);

    const lfgFactory = await hre.ethers.getContractFactory("LFGFactory");
    const LFGFactory = await lfgFactory.deploy(
        GovernanceAddress
    );
    const LFGFactoryAddress = LFGFactory.target;
    console.log("LFGFactory Address:",LFGFactoryAddress);


    //create collection
    const createCollection = await LFGFactory.createCollection(
        "Rainbow Collection",
        "Rainbow"
    );
    const createCollectionTx = await createCollection.wait();
    console.log("Create collection success:", createCollectionTx);

    const collectionAddress = await LFGFactory.IdToCollection(0);
    console.log("Collection Address:", collectionAddress);

    const Collection = new ethers.Contract(collectionAddress, LFGCollectionABI.abi, owner);
    const create = await Collection.create(
        18,
        ethers.parseEther("100000"),
        "Rainbow Story 1",
        "Story1",
        "Welcome to Rainbow Collection",
        "https://beautiful-jade-ant.myfilebase.com/ipfs/QmYxzd24zj5A93DgK21QYfAi3TBrqoofXk5fm6EyDTZi6e",
        {value: fee}
    );
    const createTx = await create.wait();
    console.log("Create success:", createTx);

    const idToTokenInfo = await Collection.getTokenInfo(0n);
    console.log("Token Info:", idToTokenInfo);
}

    main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});