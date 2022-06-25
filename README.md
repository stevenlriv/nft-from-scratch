# NFTs From Scratch

This is an outline of how an NFT project launch should work.

**Do not use the keys in the secrets.json they were already exposed to the public

## 0. Prep work

- Install [Node.js](https://nodejs.org/) to run.
- Create a new folder to work on it

## 1. Create the Smart Contract and test it

- Install dependencies

```
npm install truffle 
npx truffle init
npm install @truffle/hdwallet-provider
npm install truffle-plugin-verify
npm install ethers
npm install @openzeppelin/contracts
```

- Configure the project using truffle-config.js as a template

- Create the NFT using contact.sol as a template

- Create the deployment .js file using 2_deploy_contracts.js

- Create the secrets.json file and get all the APIs for the secret file (mnemonic, infura, etherscan)

- Create test files and test it

```
npx truffle test
```

- Deploy It

```
npx truffle migrate --network [network-name]
npx truffle run verify [CONTRACT_NAME] --network [network-name]
```

## 2. Generate all NFTs JPEGS with Jsons

- Create your art in .png formart and put it ready for IPFS
- Upload the images
- Get the hash and put it in the json file
- Then upload the json file a IPFS

## 3. Create provenance using hash.php scripts

- Hash all images 
- Take that chain sequence and then hash it
- Thats the provenance

## 4. Practice 2 more deployments of the smart contract

- This is to make sure the smart contract works correctly

## 5. How to do a project launch

To perform this actions you can use etherscan platform and directly interact with the smart contract. Or interact with the smart contract via terminal. Below in section 6 is explained.

Preparation

- Set max amount of token to mint per wallet (setMaxPublicMint)
- Set price per nft token this price per token is done in wei (setPricePerToken) [Ether/Wei Converter](https://eth-converter.com)
    - 80000000000000000 = 0.08 ETH
    - 200000000000000000 = 0.2 ETH
- Set up provenance value (setProvenance)
- Set up the royalties and wallet (setDefaultRoyalty(address, fee))
    - fee is in basis points: 1000 = 10%
    - 750 = 7.5%
- Perform the reserve function (reserve) if needed
- Setup OpenSea Collection Profile and royalty address (Images, Description, Socials)

NFT Sale

- Enable sale (setSaleState)
- On Reveal Add IPFS image url (setBaseURI)

After Sale Ends

- Turn off contract (setSaleState)

## 6. How to interact with a smart contract via terminal

Enter the console in the terminal

For local host 

```
npx truffle console 
```

For any other network

```
npx truffle console --network [network-name]
```

In the console type the address of your smart contract 

```
const contract = await SmartContractNameHere.deployed()
```

 OR

```
const contract = await SmartContractNameHere.at('ADDRESS_HERE');
```

Now you can call contract functions by doing the following

```
await contract.getName();
```

To get the abi and see all the functions available you can call

```
await contract.abi;
```

## EXTRA - Whitelist for your smart contract

Add this to your smart contract

```
   /**
     * Whitelist
     */
    bool public isAllowListActive = false;
    mapping(address => uint8) private _allowList;

    function setIsAllowListActive(bool _isAllowListActive) external onlyOwner {
        isAllowListActive = _isAllowListActive;
    }

    function setAllowList(address[] calldata addresses, uint8 numAllowedToMint) external onlyOwner {
        for (uint256 i = 0; i < addresses.length; i++) {
            _allowList[addresses[i]] = numAllowedToMint;
        }
    }

    function numAvailableToMint(address addr) external view returns (uint8) {
        return _allowList[addr];
    }

    function mintAllowList(uint8 numberOfTokens) external payable {
        uint256 ts = totalSupply();
        require(isAllowListActive, "Allow list is not active");
        require(numberOfTokens <= _allowList[msg.sender], "Exceeded max available to purchase");
        require(numberOfTokens <= MAX_PUBLIC_MINT, "Exceeded max token purchase");
        require(ts + numberOfTokens <= MAX_SUPPLY, "Purchase would exceed max tokens");
        require(PRICE_PER_TOKEN * numberOfTokens <= msg.value, "Ether value sent is not correct");

        _allowList[msg.sender] -= numberOfTokens;
        for (uint256 i = 0; i < numberOfTokens; i++) {
            _safeMint(msg.sender, ts + i);
        }
    }
```

These are the smart contracts tests

```
    describe("lets test the whitelist", async () => {
        let address_1 = '0xC627257eA77eD6B467D4376D237Bce8acB816C91';
        let address_2 = '0xe6b543E2BF7AFD7759Bae68F6E456d13d638e076';

        it("enable AllowList", async () => {
            await sc.setIsAllowListActive(true);
            const isAllowList = await sc.isAllowListActive();
            assert.equal(isAllowList, true, "The allow list must be active.");
        });

        it("lets add 3 address to the whitelist with 10 tokens to mint", async () => {
            await sc.setAllowList([address_1, address_2, currentAccount], 10);
        });

        it("lets verify if address number 1 can mint 10", async () => {
            const getValueAdd_1 = await sc.numAvailableToMint(address_1);
            assert.equal(getValueAdd_1 , 10, "The address #1 mint is limited to 10 NFTs");
        });

        it("lets verify if address number 2 can mint 10", async () => {
            const getValueAdd_2 = await sc.numAvailableToMint(address_2);
            assert.equal(getValueAdd_2 , 10, "The address #2 mint is limited to 10 NFTs");
        });

        it("test a whitlist NFT MINT", async () => {
            const mintNFT = await sc.mintAllowList(2, {value: 160000000000000000});
        });
    });
```