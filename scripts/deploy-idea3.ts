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
  const nft = await NFT.deploy(sbt.address);
  await nft.deployed();
  console.log("nft deploy to ", nft.address);

  await (await sbt.setApprover(nft.address)).wait();

  await (
    await sbt.submitIdea(
      "一个基于人脸识别的 pfp 生成 NFT 项目和工具",
      " 一个基于人脸识别的 pfp 生成 NFT 项目和工具，通过人脸识别来组装各种卡通组件，定制自己的 PFP",
      "芋头"
    )
  ).wait();

  await (
    await sbt.submitIdea("公平公正的黑客松或者 demo day 评选机制", "，基于链上投票等", "Bruce")
  ).wait();

  console.log("sbt submit idea");

  await (await nft.approveIdea(1)).wait();

  console.log("nft approve sbt ");
  // console.log(await idea3.tokenURI(0));
};

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
