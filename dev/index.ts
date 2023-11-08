import { Exchange, NFT1, NFT2, NFT3, Token1, Token2, Token3, X } from '../typechain-types';
import { deployContract, getContract, init, meta } from './utils';

async function main() {
  await meta();
  // await deployContract<Exchange>('Exchange');
  // return;
  const nft1 = await getContract<NFT1>('NFT1', '0xa513E6E4b8f2a923D98304ec87F64353C4D5C853');
  const nft2 = await getContract<NFT2>('NFT2', '0x2279B7A0a67DB372996a5FaB50D91eAA73d2eBe6');
  const nft3 = await getContract<NFT3>('NFT3', '0x8A791620dd6260079BF849Dc5567aDC3F2FdC318');
  const token1 = await getContract<Token1>('Token1', '0x610178dA211FEF7D417bC0e6FeD39F05609AD788');
  const token2 = await getContract<Token2>('Token2', '0xB7f8BC63BbcaD18155201308C8f3540b07f84F5e');
  const token3 = await getContract<Token3>('Token3', '0xA51c1fc2f0D1a1b8494Ed1FE312d7C3a78Ed91C0');
  const exchange = await getContract<Exchange>('Exchange', '0x9A676e781A523b5d0C0e43731313A708CB607508');

  // await nft1.mint();
  // console.log(await nft1.totalSupply());
  // await nft1.approve('0x9A676e781A523b5d0C0e43731313A708CB607508', 1);
  // await exchange.limitSell(
  //   '0xa513E6E4b8f2a923D98304ec87F64353C4D5C853',
  //   1,
  //   1000,
  // );
  // console.log(
  //   await exchange.orders('0xa513E6E4b8f2a923D98304ec87F64353C4D5C853', 1)
  // );
  await exchange.targetedBuy(
    '0xa513E6E4b8f2a923D98304ec87F64353C4D5C853',
    1,
    {
      value: 1000
    },
  )
}

async function dev() {
  await init();
  main();
}

dev();
