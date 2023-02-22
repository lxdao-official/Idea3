# Idea3 - Publish, Own, and Sell Your Ideas on the Blockchain

Idea3 is a platform for publishing, owning, and selling ideas on the blockchain.

测试环境地址：[](https://idea3-frontend.vercel.app/)

合约代码地址：[](https://github.com/lxdao-official/Idea3)

前端代码地址：[](https://github.com/lxdao-official/idea3-frontend)

### 他的主流程如下：

1. 将你的点子发布到区块链上。
2. 你的点子将会铸造成为一个 SBT，此 SBT 代表你对这个点子的拥有权。
3. 通过 LXDAO 的认证（approve），点子将会被铸造为一个正式的新的 ERC721 NFT.
4. 你可以通过合约内置的交易功能，将你的点子直接出售给其他人，也可以通过正常的 NFT 交易市场出售你的 NFT。
5. 此 ERC721 NFT 可以被任何人购买，持有此 NFT 者代表获得此 NFT 的使用权。
6. 即使你的 NFT 被其他人购买，你仍然是此 NFT 的原始提交者，你的地址信息将永久铸造在 NFT 头像和属性中。

### 此合约包含：

1. ERC721 SBT 合约扩展。
2. ERC721 可交易 合约扩展。
3. ERC721 链上动态 MetaData 合约扩展。
4. idea3 主合约。

### dapps 功能：

1. 提交点子
2. 点子列表（已提交，已认证）
3. 管理员 approve 入口
4. list 点子
5. buy 点子

### the nft will be like this

<img src="https://openseauserdata.com/files/395e804d75f647588c5862795f4ddd73.svg" width="350" />
