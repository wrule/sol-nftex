import { ethers } from 'hardhat';
import { Exchange, NFT1, NFT2, NFT3, Token1, Token2, Token3, X } from '../typechain-types';
import { deployContract, getContract, getSigner, init, meta } from './utils';

async function main() {
  await meta();
  const signer = getSigner();
  const nft1 = await getContract<NFT1>('NFT1', '0x5FbDB2315678afecb367f032d93F642f64180aa3');
  const token1 = await getContract<Token1>('Token1', '0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512');
  const exchange = await getContract<Exchange>('Exchange', '0xA51c1fc2f0D1a1b8494Ed1FE312d7C3a78Ed91C0');
  // await nft1.mint();
  console.log(await nft1.balanceOf(signer.address));

  await nft1.setApprovalForAll(await exchange.getAddress(), true);

  await exchange.limitSell(
    '0x5FbDB2315678afecb367f032d93F642f64180aa3',
    5,
    ethers.parseEther('3.1'),
  );

  console.log(await exchange.getOrderViews());
}

async function dev() {
  await init();
  main();
}

dev();
