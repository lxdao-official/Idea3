import { BigNumber, utils } from "ethers";
import { ethers, run } from "hardhat";
import fs from "fs";
import path from "path";
import open from "open";
const main = async () => {
  // Compile contracts
  // await run("compile");
  // console.log("Compiled contracts.");
  const [deployer] = await ethers.getSigners();
  console.log("deployer.address", deployer.address);

  const DID = await ethers.getContractFactory("IdeaDID");
  const did = await DID.deploy(true);
  await did.deployed();
  console.log("did deploy to ", did.address);

  await (await did.setOpen(true)).wait();

  await (await did.mint("idea3")).wait();

  await (await did.lockDid("idea3")).wait();

  const HandleProxyForDID = await ethers.getContractFactory("HandleProxyForDID");
  const handleProxyForDID = await HandleProxyForDID.deploy(did.address);
  await handleProxyForDID.deployed();
  console.log("handleProxyForDID deploy to ", handleProxyForDID.address);

  const SBT = await ethers.getContractFactory("IdeaSBT");
  const sbt = await SBT.deploy(handleProxyForDID.address);
  await sbt.deployed();

  // const sbt = SBT.attach("0x10F76ae93dF55FC1d971EEFdc0B3c769c6c85469");
  console.log("sbt deploy to ", sbt.address);

  // return;
  // const NFT = await ethers.getContractFactory("IdeaNFT");
  // const nft = await NFT.deploy(sbt.address);
  // await nft.deployed();
  // console.log("nft deploy to ", nft.address);

  // await (await sbt.setApprover(nft.address)).wait();

  await (
    await sbt.submitIdea(
      "Idea3 - Make more ideas reality",
      "Share your ideas, get $IDEA and support from the community, and make it reality.",
      "[https://idea3.link](https://idea3.link)"
    )
  ).wait();

  // await (
  //   await sbt.editIdeaByOwner(
  //     2,
  //     "A face recognition based pfp generating NFT project and tools",
  //     "Use face recognition to combine building block faces or body parts and expressions into personalized NFT PFP",
  //     ""
  //   )
  // ).wait();

  console.log("sbt submit idea");

  // await (await nft.approveIdea(1)).wait();

  console.log("nft approve sbt ");

  // check metadata and Image
  const tokenURL = await sbt.tokenURI(0);
  const metadata = atob(tokenURL.replace("data:application/json;base64,", ""));

  const metadataJSON = JSON.parse(metadata);

  console.log("metadataJSON", metadataJSON);

  const image = metadataJSON.image.replace("data:image/svg+xml;base64,", "");
  const svg = atob(image);

  fs.writeFileSync("scripts/idea3.svg", svg);

  // 浏览器打开此 svg

  open(path.join(__dirname, "idea3.svg"), {
    app: {
      name: "google chrome",
    },
  });
};

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
