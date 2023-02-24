import { BigNumber, utils } from "ethers";
import { ethers, run } from "hardhat";

const main = async () => {
  // Compile contracts
  // await run("compile");
  // console.log("Compiled contracts.");
  const [deployer] = await ethers.getSigners();
  console.log("deployer.address", deployer.address);
  const SBT = await ethers.getContractFactory("IdeaSBT");
  // const sbt = await SBT.deploy();
  // await sbt.deployed();

  const sbt = SBT.attach("0x10F76ae93dF55FC1d971EEFdc0B3c769c6c85469");
  console.log("sbt deploy to ", sbt.address);
  // return;
  // const NFT = await ethers.getContractFactory("IdeaNFT");
  // const nft = await NFT.deploy(sbt.address);
  // await nft.deployed();
  // console.log("nft deploy to ", nft.address);

  // await (await sbt.setApprover(nft.address)).wait();

  // await (
  //   await sbt.submitIdea(
  //     "Idea3 - Make more ideas reality",
  //     "Share your ideas, get $IDEA and support from the community, and make it reality.",
  //     "[https://idea3.link](https://idea3.link)",
  //     "LXDAO"
  //   )
  // ).wait();

  await (
    await sbt.editIdeaByOwner(
      2,
      "A face recognition based pfp generating NFT project and tools",
      "Use face recognition to combine building block faces or body parts and expressions into personalized NFT PFP",
      "",
      "0x1998"
    )
  ).wait();

  console.log("sbt submit idea");

  // await (await nft.approveIdea(1)).wait();

  console.log("nft approve sbt ");
  // console.log(await sbt.tokenURI(2));
};

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
