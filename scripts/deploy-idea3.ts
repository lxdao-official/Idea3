import { BigNumber, utils } from "ethers";
import { ethers, run } from "hardhat";

const main = async () => {
  // Compile contracts
  // await run("compile");
  // console.log("Compiled contracts.");
  const [deployer] = await ethers.getSigners();
  console.log("deployer.address", deployer.address);
  const SBT = await ethers.getContractFactory("IdeaSBT");
  const sbt = await SBT.deploy();
  await sbt.deployed();

  console.log("sbt deploy to ", sbt.address);
  // return;
  const NFT = await ethers.getContractFactory("IdeaNFT");
  // const nft = await NFT.deploy(sbt.address);
  // await nft.deployed();
  // console.log("nft deploy to ", nft.address);

  // await (await sbt.setApprover(nft.address)).wait();

  await (
    await sbt.submitIdea(
      "IdeasDAO - Make more ideas reality",
      "Share your ideas, get $IDEA and support from the community, and make it reality.",
      "[https://ideasdao.xyz](https://ideasdao.xyz)",
      "LXDAO"
    )
  ).wait();

  // await (
  //   await sbt.submitIdea("公平公正的黑客松或者 demo day 评选机制", "，基于链上投票等", "Bruce")
  // ).wait();

  console.log("sbt submit idea");

  // await (await nft.approveIdea(1)).wait();

  console.log("nft approve sbt ");
  console.log(await sbt.tokenURI(0));
};

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
