import { ethers } from 'hardhat';
import { Exchange, NFT1, NFT2, NFT3, Token1, Token2, Token3, X } from '../typechain-types';
import { deployContract, getContract, getSigner, init, meta } from './utils';

async function main() {
  await meta();
  
}

async function dev() {
  await init();
  main();
}

dev();
