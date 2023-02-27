import { IdeaSBT } from "./../typechain-types/contracts/idea3/IdeaSBT";
import { ethers } from "hardhat";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";

const { expect } = require("chai");

describe("ideaSBT test", function () {
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
    [owner] = await ethers.getSigners();
    await sbt.deployed();
  });

  it("correctly report idea and emit TopicSubmitted", async function () {
    expect(
      await (
        await sbt.submitIdea(
          "Idea3 - Make more ideas reality",
          "Share your ideas, get $IDEA and support from the community, and make it reality.",
          "[https://idea3.link](https://idea3.link)"
        )
      ).wait()
    ).to.emit(sbt, "TopicSubmitted");
  });

  it("check metadata and image", async function () {
    const TEST_NAME = "test name";
    const TEST_DESCRIPTION = "test description";
    const TEST_MARKDOWN = "test markdown";
    await (await sbt.submitIdea(TEST_NAME, TEST_DESCRIPTION, TEST_MARKDOWN)).wait();
    const tokenURL = await sbt.tokenURI(0);
    const metadata = atob(tokenURL.replace("data:application/json;base64,", ""));

    const metadataJSON = JSON.parse(metadata);

    await expect(metadataJSON.name).to.equal("#0 " + TEST_NAME);
    await expect(metadataJSON.description).to.equal(TEST_DESCRIPTION);

    const image = metadataJSON.image.replace("data:image/svg+xml;base64,", "");

    const svg = atob(image);

    await expect(svg).to.equal(
      "<svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' width='1024' height='1024' viewBox='0 0 400 400' fill='none'><defs><path xmlns='http://www.w3.org/2000/svg' id='text-path-a' d='M 20 10 H 380 A 28 28 0 0 1 390 20 V 380 A 28 28 0 0 1 380 390 H 20 A 28 28 0 0 1 10 380 V 20 A 28 28 0 0 1 20 10 z' /><clipPath xmlns='http://www.w3.org/2000/svg' id='corners'><rect width='400' height='400' rx='18' ry='18' /></clipPath></defs><g opacity='1' transform='translate(0 0)' font-family='Courier New, monospace'><g xmlns='http://www.w3.org/2000/svg' clip-path='url(#corners)'><rect x='0' y='0' width='400' height='400' rx='15' ry='15' fill='rgba(40,40,40,1)' /></g><g opacity='1' transform='translate(25 25) '><foreignObject width='360' height='250'><body xmlns='http://www.w3.org/1999/xhtml' style='margin:0;padding:0;'><p style='font-size:24px;margin:0;color:#fff;'>#0 test name</p> <p style='font-size:14px;margin:0;color:#fff;margin-top:16px;'>test description</p></body></foreignObject></g><g xmlns='http://www.w3.org/2000/svg' transform='translate(25 280) '><foreignObject width='350' height='100'><body xmlns='http://www.w3.org/1999/xhtml' style='margin:0;padding:0;padding-top:5px;'><div style='margin-bottom:15px;'><p style='display:inline;font-size:12px;margin:0;color:#fff;background:rgba(0,0,0,0.6);border-radius:8px;padding:7px 10px;'><span style='color:rgba(255,255,255,0.6)'>Approved </span>No</p></div><div style='margin-bottom:12px;'><p style='display:inline;font-size:12px;margin:0;color:#fff;background:rgba(0,0,0,0.6);border-radius:8px;padding:7px 10px;'><span style='color:rgba(255,255,255,0.6)'>Idea by </span>idea3</p></div><div><p style='font-size:12px;margin:0;color:#fff;background:rgba(0,0,0,0.6);border-radius:8px;padding:7px 10px;'>f39fd6e51aad88f6f4ce6ab8827279cfffb92266</p></div></body></foreignObject></g><text text-rendering='optimizeSpeed'><textPath startOffset='-100%' fill='#fff' font-family='Courier New, monospace' font-size='12px' font-weight='500' xmlns:xlink='http://www.w3.org/1999/xlink' xlink:href='#text-path-a'>f39fd6e51aad88f6f4ce6ab8827279cfffb92266<animate additive='sum' attributeName='startOffset' from='0%' to='100%' begin='0s' dur='30s' repeatCount='indefinite' /></textPath><textPath startOffset='0%' fill='#fff' font-family='Courier New, monospace' font-size='12px' font-weight='500' xmlns:xlink='http://www.w3.org/1999/xlink' xlink:href='#text-path-a'>f39fd6e51aad88f6f4ce6ab8827279cfffb92266<animate additive='sum' attributeName='startOffset' from='0%' to='100%' begin='0s' dur='30s' repeatCount='indefinite' /></textPath><textPath startOffset='-50%' fill='#fff' font-family='Courier New, monospace' font-size='12px' font-weight='500' xmlns:xlink='http://www.w3.org/1999/xlink' xlink:href='#text-path-a'>f39fd6e51aad88f6f4ce6ab8827279cfffb92266<animate additive='sum' attributeName='startOffset' from='0%' to='100%' begin='0s' dur='30s' repeatCount='indefinite' /></textPath><textPath startOffset='50%' fill='#fff' font-family='Courier New, monospace' font-size='12px' font-weight='500' xmlns:xlink='http://www.w3.org/1999/xlink' xlink:href='#text-path-a'>f39fd6e51aad88f6f4ce6ab8827279cfffb92266<animate additive='sum' attributeName='startOffset' from='0%' to='100%' begin='0s' dur='30s' repeatCount='indefinite' /></textPath></text></g></svg>"
    );
  });
});
