# Idea3 - Make more ideas reality

## our mission

Make more ideas reality

Share ideas, discuss ideas, get $IDEA and support from the community, make it reality together.

合约代码地址：[https://github.com/lxdao-official/Idea3](https://github.com/lxdao-official/Idea3)

前端代码地址：[https://github.com/lxdao-official/idea3-frontend](https://github.com/lxdao-official/idea3-frontend)

### 他的主要模块如下：

1. DID 合约
   1. 用户首先需要 mint 一个 did，did 会被铸造成为一个 ERC721 NFT（DIDNFT）。
   2. 将 did 和用户的钱包地址绑定，绑定后即可互相解析。
   3. 被绑定的 did nft 不可转移，未绑定的 did nft 可以转移，已绑定的 did nft 可以解绑。
1. 内容合约
   1. 将你的点子发布到区块链上。
   1. 你的点子将会铸造成为一个 SBT（IdeaSBT)，此 SBT 代表你对这个点子的拥有权。
   1. 所有人都可以对你的点子进行“补充”，补充的内容将会被铸造为一个新的 SBT（SubIdeaSBT）。
   1. 所有人都可以对你的点子进行“点赞”，点赞的内容将会被铸造为一个新的 SBT（LikeIdeaSBT）。
1. 治理合约
   1. 每周举行一次社区投票，通过投票的优秀的 idea 会被官方 approve。
   1. approve 的同时，会从 $IDEA 矿池中挖出一定数量的 $IDEA 锁定在此 idea 中作为对优秀 idea 的奖励。
   1. 被 approve 的 idea 会被铸造成精美的 ERC721 NFT（GoodIdeaNFT），并在官网推荐，此 NFT 可以出售。
1. 捐赠合约
   1. 所有人都可以使用 $IDEA 为某个 idea 捐赠，捐赠的 $IDEA 同样锁定在 idea 中。
   1. 捐赠的同时，$IDEA 的配捐池会以一定比例配捐。
1. 锁仓合约
   1. 每个 idea 内锁定的 $IDEA 40% 属于发布者，60% 属于参与者（补充和点赞，这 70%怎么分需要再设计）。
   1. 行为发生 7 天后，发布者和参与者可以 claim 属于自己份额的代币。
1. 众筹合约：
   1. 暂不设计
1. 代币合约：
   1. $IDEA 代币是一个 ERC20 代币，用于在 idea3 平台内部流通。
   1. 锁仓和解锁机制

### 关于合约的设计

1. 递进式功能叠加，从基础模块开始，一步一步叠加合约。
2. 沉淀基础合约，如 sbt 、svg metadata 等。
3. 沉淀基础模块，如 topic、like、comment 等，并由此模块构建更高级的模块，如 idea、subidea、likeidea 等。

### contracts

- [base/](./contracts/base)
  - [did/](./contracts/base/did)
    - DID NFT minting and binding to wallet address.
    - Resolve DID to wallet address, resolve wallet address to DID etc.
    - DID Price management contract.
  - [lib/](./contracts/base/lib)
    - Basic library for string and ownable etc.
  - [metadata/](./contracts/base/metadata)
    - SVG Dynamic Metadata contract.
  - [sbt/](./contracts/base/sbt)
    - SBT721 and SBT1155 contract.
  - [topic/](./contracts/base/topic)
    - Basic content management contract.
    - Topic, Comment, Like, Tag, etc.
  - [tradable/](./contracts/base/tradable)
    - ERC721 tradable extension contract.
- [idea3/](./contracts/idea3)
  - [proxy/](./contracts/idea3/proxy)
    - Handle proxy contract for idea3. Compatible within self did contract and other did contract.
  - Idea3 bussiness logic contract.
