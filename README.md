# Carabelas de Colón — NFT Collection

An ERC-721 NFT collection of the three ships from Columbus' 1492 expedition: the **Pinta**, the **Niña** and the **Santa María**. Built with Solidity, Foundry and OpenZeppelin as a course project.

[![CI](https://github.com/daboy-dev/nft-collection/actions/workflows/test.yml/badge.svg)](https://github.com/daboy-dev/nft-collection/actions/workflows/test.yml)

## Live deployment

| | |
|---|---|
| **Network** | Arbitrum One |
| **Contract** | [`0x1f5931e28337681f396f0bcd02063efca00d8e4a`](https://arbiscan.io/address/0x1f5931e28337681f396f0bcd02063efca00d8e4a) |
| **Collection** | Carabelas de Colon (`3CARAB`) |
| **OpenSea** | [carabelas-de-colon](https://opensea.io/collection/carabelas-de-colon) |

## The collection

Total supply: **3**. Token IDs go from `0` to `2`.

| Token ID | Name | Rarity | Type |
|---|---|---|---|
| 0 | Pinta | Common | Caravel |
| 1 | Niña | Rare | Caravel |
| 2 | Santa María | Legendary | Nao |

Metadata lives in [`uris/`](uris) as one JSON file per token (`0.json`, `1.json`, `2.json`) and is pinned on IPFS. The images are also stored on IPFS.

## Contract

[`NFTCollection`](src/NFTCollection.sol) extends OpenZeppelin's `ERC721`:

- `mint()` — open to anyone; mints the next token ID to the caller until the supply is reached (then reverts with `Sold out!`).
- `tokenURI(tokenId)` — returns `baseUri + tokenId + ".json"`.
- `currentTokenId`, `totalSupply`, `baseUri` — public state.
- `MintNFT(address userAddress, uint256 tokenId)` — emitted on every mint.

Name, symbol, total supply and base URI are passed to the constructor at deploy time.

## Getting started

Requires [Foundry](https://book.getfoundry.sh/getting-started/installation).

```shell
git clone --recurse-submodules git@github.com:daboy-dev/nft-collection.git
cd nft-collection
forge build
forge test
```

## Deploy

1. Create a `.env` file (it is git-ignored):

   ```
   PRIVATE_KEY=0x<your_private_key>
   ETHERSCAN_API_KEY=<your_api_key>
   ```

   Use a dedicated test wallet, never an account holding real funds.

2. Run the script:

   ```shell
   source .env
   forge script script/DeployNFTCollection.s.sol \
     --rpc-url <RPC_URL> \
     --broadcast \
     --verify
   ```

   Omit `--broadcast` to simulate the deployment without sending transactions.

3. If the contract was deployed but not verified, verify it afterwards:

   ```shell
   forge verify-contract <CONTRACT_ADDRESS> \
     src/NFTCollection.sol:NFTCollection \
     --chain arbitrum \
     --etherscan-api-key $ETHERSCAN_API_KEY \
     --constructor-args $(cast abi-encode "constructor(string,string,uint256,string)" \
       "Carabelas de Colon" "3CARAB" 3 "<BASE_URI>") \
     --watch
   ```

## Project structure

```
src/        NFTCollection.sol — the ERC-721 contract
script/     DeployNFTCollection.s.sol — deployment script
test/       Forge tests
uris/       Token metadata (JSON)
lib/        Dependencies (forge-std, OpenZeppelin) as git submodules
```

## License

MIT
