import Swap from 0x02
import FlowToken from 0x7e60df042a9c0868
import MyToken from 0x01
import FungibleToken from 0x9a0766d93b6608b7

transaction(amount: UFix64) {
    let flowVaultRef: &FlowToken.Vault{FungibleToken.Provider, FungibleToken.Balance}
    let myTokenVault: &{FungibleToken.Receiver}

    prepare(signer: AuthAccount) {
        self.flowVaultRef = signer.borrow<&FlowToken.Vault{FungibleToken.Provider, FungibleToken.Balance}>(from: /storage/flowTokenVault)
            ?? panic("Could not borrow Flow Token vault reference")

        self.myTokenVault = signer.getCapability(/public/MyTokenVault)
            .borrow<&{FungibleToken.Receiver}>()
            ?? panic("Could not borrow MyToken vault receiver reference")
    }

    execute {
        let swappedTokens <- Swap.swapWithReference(flowVaultRef: self.flowVaultRef)
        self.myTokenVault.deposit(from: <-swappedTokens)
    }
}