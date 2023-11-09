import { ethers } from 'hardhat';
import { Exchange, NFT1, NFT2, NFT3, Token1, Token2, Token3, X } from '../typechain-types';
import { deployContract, getContract, getSigner, init, meta } from './utils';

async function main() {
  await meta();
  const signer = getSigner();
  const nft1 = await getContract<NFT1>('NFT1', '0x5FbDB2315678afecb367f032d93F642f64180aa3');
  const token1 = await getContract<Token1>('Token1', '0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512');
  const exchange = await getContract<Exchange>('Exchange', '0x610178dA211FEF7D417bC0e6FeD39F05609AD788');
  // await nft1.mint();
  console.log(await nft1.balanceOf(signer.address));

  // console.log(exchange.orderViews);
}

async function dev() {
  await init();
  main();
}

dev();
