import FlowToken from 0x7e60df042a9c0868
import MyToken from 0x01
import FungibleToken from 0x9a0766d93b6608b7

pub contract Swap {
    pub var lastSwapTimestamp: {Address: UFix64}

    pub resource SwapIdentity {
        pub let owner: Address

        init(owner: Address) {
            self.owner = owner
        }
    }

    pub fun createSwapIdentity(): @SwapIdentity {
        return <-create SwapIdentity(owner: self.account.address)
    }

    pub fun swapWithVault(flowVault: @FlowToken.Vault, swapper: Address): @MyToken.Vault {
        let amount = flowVault.balance
        destroy flowVault

        let lastSwap = self.lastSwapTimestamp[swapper] ?? 0.0
        let currentTime = getCurrentBlock().timestamp
        let tokensToMint = 2.0 * (currentTime - lastSwap)

        self.lastSwapTimestamp[swapper] = currentTime

        let minter = MyToken.account.borrow<&MyToken.Minter>(from: /storage/MyTokenMinter)
            ?? panic("Could not borrow minter reference")
        return <-minter.mintTokens(amount: tokensToMint)
    }

    pub fun swapWithReference(flowVaultRef: &FlowToken.Vault{FungibleToken.Provider, FungibleToken.Balance}): @MyToken.Vault {
        let swapper = flowVaultRef.owner!.address
        let flowVault <- flowVaultRef.withdraw(amount: flowVaultRef.balance)
        return <-self.swapWithVault(flowVault: <-flowVault, swapper: swapper)
    }

    init() {
        self.lastSwapTimestamp = {}
    }
}
