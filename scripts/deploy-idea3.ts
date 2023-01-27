import { BigNumber, utils } from "ethers";
import { ethers, run } from "hardhat";

const main = async () => {
  // Compile contracts
  // await run("compile");
  // console.log("Compiled contracts.");
  const [deployer] = await ethers.getSigners();
  console.log("deployer.address", deployer.address);
  const POAP = await ethers.getContractFactory("POAP");
  const ideator = await POAP.deploy("POAP For ideator", "ideator");
  await ideator.deployed();

  console.log("ideator deploy to ", ideator.address);
  // return;
  const Idea3 = await ethers.getContractFactory("Idea");
  const idea3 = await Idea3.deploy(ideator.address);
  await idea3.deployed();

  await (await ideator.connect(deployer).transferOwnership(idea3.address)).wait();
  console.log("idea3 deploy to ", idea3.address);

  await (
    await idea3.submitIdea(
      "一个基于人脸识别的 pfp 生成 NFT 项目和工具",
      " 一个基于人脸识别的 pfp 生成 NFT 项目和工具，通过人脸识别来组装各种卡通组件，定制自己的 PFP",
      "芋头"
    )
  ).wait();

  // console.log(await idea3.tokenURI(0));
};

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
