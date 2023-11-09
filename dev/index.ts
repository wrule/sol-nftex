import { ethers } from 'hardhat';
import { Exchange, NFT1, NFT2, NFT3, Token1, Token2, Token3, X } from '../typechain-types';
import { deployContract, getContract, getSigner, init, meta } from './utils';

async function main() {
  await meta();
  const nft1 = await getContract<NFT1>('NFT1', '0x5FbDB2315678afecb367f032d93F642f64180aa3');
  const token1 = await getContract<Token1>('Token1', '0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512');
  console.log(
    await nft1.name(),
    await token1.name(),
  );
}

async function dev() {
  await init();
  main();
}

dev();
