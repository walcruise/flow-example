import Swap from 0x02
import FlowToken from 0x7e60df042a9c0868
import MyToken from 0x01
import FungibleToken from 0x9a0766d93b6608b7

transaction(amount: UFix64) {
    let flowVault: @FlowToken.Vault
    let swapIdentity: @Swap.SwapIdentity
    let myTokenVault: &{FungibleToken.Receiver}

    prepare(signer: AuthAccount) {
        self.flowVault <- signer.borrow<&FlowToken.Vault>(from: /storage/flowTokenVault)!
            .withdraw(amount: amount) as! @FlowToken.Vault

        self.swapIdentity <- signer.load<@Swap.SwapIdentity>(from: /storage/SwapIdentity)
            ?? panic("SwapIdentity not found")

        self.myTokenVault = signer.getCapability(/public/MyTokenVault)
            .borrow<&{FungibleToken.Receiver}>()
            ?? panic("Could not borrow MyToken vault receiver reference")
    }

    execute {
        let swappedTokens <- Swap.swapWithVault(flowVault: <-self.flowVault, swapper: self.swapIdentity.owner)
        self.myTokenVault.deposit(from: <-swappedTokens)
        signer.save(<-self.swapIdentity, to: /storage/SwapIdentity)
    }
}