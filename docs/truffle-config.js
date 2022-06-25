const ethers = require('ethers');
const HDWalletProvider = require('@truffle/hdwallet-provider');
const { mnemonic, infuraApiKey, etherscanApiKey, snowtraceApiKey } = require('./secrets.json');

module.exports = {
  networks: {
    fuji: {
      provider: () => new HDWalletProvider(mnemonic, `https://api.avax-test.network/ext/bc/C/rpc`),
      network_id: "43113",
      timeoutBlocks: 200,
      confirmations: 5
    },
    ropsten: {
      provider: () => new HDWalletProvider(mnemonic, `https://ropsten.infura.io/v3/${infuraApiKey}`),
      network_id: 3,       // Ropsten's id
      gas: 5500000,        // Ropsten has a lower block limit than mainnet
      confirmations: 2,    // # of confs to wait between deployments. (default: 0)
      timeoutBlocks: 200,  // # of blocks before a deployment times out  (minimum/default: 50)
      skipDryRun: true     // Skip dry run before migrations? (default: false for public nets )
    },
    rinkeby: {
      provider: () => new HDWalletProvider(mnemonic, `https://rinkeby.infura.io/v3/${infuraApiKey}`),
      network_id: 4,
      gasPrice: 10e9,
      skipDryRun: true,
    },
    mainnet: {
      provider: () => new HDWalletProvider(mnemonic, `https://mainnet.infura.io/v3/${infuraApiKey}`),
      network_id: 1,
      gas: 4118518,
      gasPrice: 70000000000,
    },
    avalanche_mainnet: {
      provider: () => new HDWalletProvider(mnemonic, `https://api.avax.network/ext/bc/C/rpc`),
      network_id: "*",
      skipDryRun: true,
    },
  },
  mocha: {
    // timeout: 100000
  },
  compilers: {
    solc: {
      version: "0.8.11",    // Fetch exact version from solc-bin (default: truffle's version)
    }
  },
  plugins: [
    'truffle-plugin-verify'
  ],
  api_keys: {
    etherscan: etherscanApiKey,
    snowtrace: snowtraceApiKey
  }
};