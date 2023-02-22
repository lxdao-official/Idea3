const { expect } = require("chai");

describe("idea3", function () {
  let sbt, owner, bob, jane, sara;
  const zeroAddress = "0x0000000000000000000000000000000000000000";

  beforeEach(async () => {
    const SBT = await ethers.getContractFactory("IdeaSBT");
    sbt = await SBT.deploy();
    [owner, p1, p2, p3, p4, p5, p6] = await ethers.getSigners();
    console.log("sbt deploy to ", sbt.address);
    await sbt.deployed();
  });

  it("correctly report idea", async function () {
    await (
      await sbt
        .connect(owner)
        .submitIdea(
          "IdeasDAO - Make more ideas reality",
          "Share your ideas, get $IDEA and support from the community, and make it reality.",
          "[https://ideasdao.xyz](https://ideasdao.xyz)",
          "LXDAO"
        )
    ).wait();
  });
});
