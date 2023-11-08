import { NFT1, NFT2, NFT3, Token1, Token2, Token3, X } from '../typechain-types';
import { deployContract, init, meta } from './utils';

async function main() {
  await meta();

  const nft1 = await deployContract<NFT1>('NFT1');
  console.log('NFT1:', await nft1.getAddress());
  const nft2 = await deployContract<NFT2>('NFT2');
  console.log('NFT2:', await nft2.getAddress());
  const nft3 = await deployContract<NFT3>('NFT3');
  console.log('NFT3:', await nft3.getAddress());

  const token1 = await deployContract<Token1>('Token1');
  console.log('Token1:', await token1.getAddress());
  const token2 = await deployContract<Token2>('Token2');
  console.log('Token2:', await token2.getAddress());
  const token3 = await deployContract<Token3>('Token3');
  console.log('Token3:', await token3.getAddress());
}

async function dev() {
  await init();
  main();
}

dev();
