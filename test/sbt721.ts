import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { ethers } from "hardhat";
import { IdeaSBT } from "../typechain-types";

const { expect } = require("chai");

describe("SBT721 test", function () {
  let sbt: IdeaSBT,
    owner: SignerWithAddress,
    bob: SignerWithAddress,
    jane: SignerWithAddress,
    sara: SignerWithAddress;
  const zeroAddress = "0x0000000000000000000000000000000000000000";

  beforeEach(async () => {
    const DID = await ethers.getContractFactory("IdeaDID");
    const did = await DID.deploy(true);
    await did.deployed();

    await (await did.updateOpen(true)).wait();
    await (await did.mint("idea3")).wait();
    await (await did.lockDid("idea3")).wait();

    const SBT = await ethers.getContractFactory("IdeaSBT");
    sbt = await SBT.deploy(did.address);
    [owner, bob, jane, sara] = await ethers.getSigners();
    await sbt.deployed();

    await (
      await sbt.submitIdea(
        "Idea3 - Make more ideas reality",
        "Share your ideas, get $IDEA and support from the community, and make it reality.",
        "[https://idea3.link](https://idea3.link)"
      )
    ).wait();
  });

  it("No Approve able", async function () {
    // revert when approve tokenId
    await expect(sbt.connect(owner).approve(zeroAddress, 0)).to.be.revertedWith("canot approve");
  });

  it("No transferable", async function () {
    // revert when transfer tokenId
    await expect(sbt.connect(owner).transferFrom(owner.address, bob.address, 0)).to.be.revertedWith(
      "canot transfer"
    );
  });
});
