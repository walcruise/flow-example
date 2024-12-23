```markdown
# Flow Token Project

## Overview

This project implements a custom fungible token (MyToken) and a token swap mechanism on the Flow blockchain. It demonstrates the creation of fungible tokens, account setup, token transfers, admin operations, and a simple swap mechanism between Flow tokens and the custom token.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Project Structure](#project-structure)
3. [Setup](#setup)
4. [Contracts](#contracts)
5. [Transactions](#transactions)
6. [Scripts](#scripts)
7. [Deployment](#deployment)
8. [Testing](#testing)
9. [Contributing](#contributing)
10. [License](#license)

## Prerequisites

- [Flow CLI](https://docs.onflow.org/flow-cli/install/)
- [VS Code](https://code.visualstudio.com/) (recommended)
- [Flow VS Code Extension](https://marketplace.visualstudio.com/items?itemName=onflow.flow) (recommended)

## Project Structure

```

flow-token-project/
│
├── contracts/
│   ├── MyToken.cdc
│   └── Swap.cdc
│
├── transactions/
│   ├── mintTokens.cdc
│   ├── setupAccount.cdc
│   ├── transferTokens.cdc
│   ├── adminWithdraw.cdc
│   ├── swapWithVault.cdc
│   └── swapWithReference.cdc
│
├── scripts/
│   ├── readBalance.cdc
│   ├── isSetupCorrectly.cdc
│   ├── getTotalSupply.cdc
│   ├── getBalances.cdc
│   └── getAllVaultInfo.cdc
│
├── flow.json
└── README.md

```plaintext

## Setup

1. Clone this repository:
```

git clone [https://github.com/walcruise/flow-example](https://github.com/yourusername/flow-token-project.git)
cd flow-token-project

```plaintext

2. Install the Flow CLI if you haven't already:
```

sh -ci "$(curl -fsSL [https://storage.googleapis.com/flow-cli/install.sh](https://storage.googleapis.com/flow-cli/install.sh))"

```plaintext

3. Initialize the Flow project (if not already initialized):
```

flow project init

```plaintext

4. Update the `flow.json` file with your account information and contract deployments.

## Contracts

### MyToken.cdc

This contract implements a custom fungible token that adheres to the Flow Fungible Token standard. It includes:

- A `Vault` resource for storing tokens
- A `Minter` resource for creating new tokens
- An `Admin` resource for special operations (e.g., withdrawing tokens from user accounts)

### Swap.cdc

This contract implements a simple swap mechanism between Flow tokens and MyToken. It includes:

- A `SwapIdentity` resource to identify swap participants
- Functions to perform swaps using either a Flow token vault or a reference

## Transactions

- `mintTokens.cdc`: Mint new MyTokens and deposit them to a recipient's vault
- `setupAccount.cdc`: Set up a MyToken vault in a user's account
- `transferTokens.cdc`: Transfer MyTokens between accounts
- `adminWithdraw.cdc`: Allow an admin to withdraw MyTokens from a user's account
- `swapWithVault.cdc`: Swap Flow tokens for MyTokens using a Flow token vault
- `swapWithReference.cdc`: Swap Flow tokens for MyTokens using a reference to a Flow token vault

## Scripts

- `readBalance.cdc`: Read the MyToken balance of an account
- `isSetupCorrectly.cdc`: Check if an account is correctly set up with a MyToken vault
- `getTotalSupply.cdc`: Get the total supply of MyTokens
- `getBalances.cdc`: Get both MyToken and Flow token balances for an account
- `getAllVaultInfo.cdc`: Get information about all fungible token vaults in an account

## Deployment

To deploy the contracts to the Flow testnet:

1. Ensure you have a testnet account set up in your `flow.json` file.
2. Run the following command:
```

flow project deploy --network testnet

```plaintext

## Testing

To test the deployment and run scripts:

1. Execute a script, e.g., to get the total supply:
```

flow scripts execute scripts/getTotalSupply.cdc --network testnet

```plaintext

2. Send a transaction, e.g., to set up an account:
```

flow transactions send transactions/setupAccount.cdc --network testnet --signer testnet-account

```plaintext

Replace `testnet-account` with the name of your testnet account as configured in `flow.json`.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) fi
```