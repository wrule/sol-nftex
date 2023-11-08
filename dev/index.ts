import { NFT1, Token1, X } from '../typechain-types';
import { deployContract, init, meta } from './utils';

async function main() {
  await meta();
  const token1 = await deployContract<Token1>('Token1');
}

async function dev() {
  await init();
  main();
}

dev();
