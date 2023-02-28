import { IdeaDID } from "./../typechain-types/contracts/idea3/IdeaDID";
import { IdeaSBT } from "../typechain-types/contracts/idea3/IdeaSBT";
import { ethers } from "hardhat";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";

const { expect } = require("chai");

describe("ideaSBT test", function () {
  let did: IdeaDID,
    owner: SignerWithAddress,
    bob: SignerWithAddress,
    jane: SignerWithAddress,
    sara: SignerWithAddress;
  const zeroAddress = "0x0000000000000000000000000000000000000000";

  beforeEach(async () => {
    const DID = await ethers.getContractFactory("IdeaDID");
    did = await DID.deploy(true);
    await did.deployed();
    await (await did.setOpen(true)).wait();
    [owner, bob] = await ethers.getSigners();
  });

  it("mint one and lock", async function () {
    expect(await (await did.mint("idea3")).wait()).to.emit(did, "Minted");
    expect(await (await did.lockDid("idea3")).wait()).to.emit(did, "Locked");
  });

  it("mint two and lock", async function () {
    expect(await (await did.mint("idea3")).wait()).to.emit(did, "Minted");
    expect(await (await did.mint("idea4")).wait()).to.emit(did, "Minted");
    expect(await (await did.lockDid("idea3")).wait()).to.emit(did, "Locked");
  });

  it("mint already exist did", async function () {
    expect(await (await did.mint("idea3")).wait()).to.emit(did, "Minted");
    await expect(did.mint("idea3")).to.be.revertedWith("did already minted");
  });

  it("locked did can not transfer", async function () {
    expect(await (await did.mint("idea3")).wait()).to.emit(did, "Minted");
    expect(await (await did.lockDid("idea3")).wait()).to.emit(did, "Locked");
    await expect(did.transferFrom(owner.address, bob.address, 1)).to.be.revertedWith(
      "token is locked"
    );
  });
});
