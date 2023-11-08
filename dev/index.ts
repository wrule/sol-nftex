import { NFT1, X } from '../typechain-types';
import { deployContract, init, meta } from './utils';

async function main() {
  await meta();
  const nft1 = await deployContract<NFT1>('NFT1');
}

async function dev() {
  await init();
  main();
}

dev();
