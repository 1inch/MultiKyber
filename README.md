# MultiKyber

Kyber smart contract wrapper for cTokens, iTokens and sTokens native support

[![Build Status](https://travis-ci.org/CryptoManiacsZone/MultiKyber.svg?branch=master)](https://travis-ci.org/CryptoManiacsZone/MultiKyber)
[![Coverage Status](https://coveralls.io/repos/github/CryptoManiacsZone/MultiKyber/badge.svg?branch=master)](https://coveralls.io/github/CryptoManiacsZone/MultiKyber?branch=master)

## Inspiration
Many people has different ERC20 tokens in an Ethereum wallet and are not able to swap direct to any Compound and Fulcrum tokens. Even it's not possible to migrate a lending position from Compound to Fulcrum or Fulcrum to Compound in one single transaction. 

## What it does
We were able to solve this problem with a small smart contract wrapper over Kyber Network Proxy smart contract, which allows to bundle, unbundle and move the loan positions in multi path manner in one single transaction. 

### Example:

ETH -> cDAI == multi path swap ==> ETH -> DAI -> cDAI

ZRX -> cETH == multi path swap ==> ZRX -> ETH -> cETH

## How I built it
We wrote a wrapper smart contract with small multi path implementation. 

## Challenges I ran into
Implementing multi path logic and debugging on the mainnet. 

## Accomplishments that I'm proud of
It's possible to use it everywhere where Kyber Network Proxy contract was already in use. Only the contract address needs to be changed.
We integrated it in our Token Swap Aggregator => https://1inch.exchange

## What I learned
How to interact with Compound and Fulcrum. 

## What's next for Multi-Kyber Swap
Integration in to KyberSwap and Kyber Network Proxy!

## MultiKyber Wrapper Contract:
https://etherscan.io/address/0xbfc22e3b81bddc185eb7c50765a9f445589a12ae#code

## GitHub Repo:
https://github.com/CryptoManiacsZone/MultiKyber
