# BREIT

## Commercial Real Estate on Block Chain

Tokenization of Real Estate where anyone From India can be a real estate owner — allowing Indians to own a part of the buildings they work in, the malls they visit, and even their favorite venues.
A Real Estate Investment Trust (REIT) is an investment instrument that offers proportionate ownership of an income-generating real estate asset to retail investors

REIT has been a recently new concept in Indian Economy with the very first REIT launched in 2019 and only Two REITS Thereafter. This is because the traditional ways of setting up REITS were expensive, Less Secure and cumbersome.
We propose a creation and ideation of a token BREIT which will Simplify the process. Builders would be registering properties and maintaining and we will onboard potential investors who can track all their real Estate on our Platform. Additionally we propose to launch an Exchange.
BREIT will allow you to invest with as little as mere thousand as in a simple, transparent liquid and secured way.

## Tokenization Flow

Real estate corporations will partner with us to develop their issuances before launching a deal. We perform a variety of tasks, including issuing and managing tokens, onboarding clients, and providing a secondary marketplace where the tokens can be traded.
Token Volumes and Prices will Increase with involvement in buying which will further strengthen the trust between builders and Investors.

Purchasing BREIT -> Liquidity -> More Builders Launching -> Rental Income Generated Converted to BREIT and BREIT Distributed back to Token Holders -> Purchasing BREIT

Each Token Holder will be getting Profits in Proportionate Amounts.

## Moving on to the One Single Question - Regulation in India?

We are planning to incorporate Auditing on Chain and Provide a Transparent, Liquid and Secured Technology To The REITS Present and upcoming REITS in the markets. This way we will only allow accredited properties and owners to Launch the Project On our Marketplace. Also Will Incorporate all the Regulatory Things on the Basis of RERA and Commercial Acts.

## Application Software Architecture

Here is the application software architecture work-flow:

Users use an Internet browser to connect to our platform which is written in React and Next and JavaScript.

Then, instead of accessing a back-end server, the website talks directly to the blockchain which is where all the codes and data for the application lives.

The Platform application codes are contained in smart contracts written in solidity programming language which was a lot like JavaScript. These smart contracts are immutable which means the code can not change and all the data is stored in the public ledger which is also immutable. And, anytime new data is added to the blockchain, it will be permanent and publicly verifiable.

We have integrated Social Login and Wallet Connect from ###Biocnomy API.
We have deployed our smart contracts on ###Polygon with the following adresses -

```cpp
Address Pool deployed at  0xe67406eDD92F215ecAE37d306682D4489d498108
Builder deployed at 0x17E632E281EFd8eb9a1ca3f1609d3349ef29AEC5
EREIT deployed at 0xaCD3C62a0DCCec683a990831A3e7185B68ca53a9
EREIT Goverance deployed at 0x8242D426Bc35DDF38b559bDe01A3f95fa797D4F2
```

Try running some of the following tasks:

```shell
npx hardhat help
npx hardhat test
npm install
npx hardhat compile
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat run scripts/deploy.js
```
