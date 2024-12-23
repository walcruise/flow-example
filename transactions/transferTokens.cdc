import MyToken from 0x01
import FungibleToken from 0x9a0766d93b6608b7

transaction(amount: UFix64, recipient: Address) {
    let senderVault: &MyToken.Vault
    let recipientVault: &{FungibleToken.Receiver}

    prepare(signer: AuthAccount) {
        self.senderVault = signer.borrow<&MyToken.Vault>(from: /storage/MyTokenVault)
            ?? panic("Could not borrow sender vault")
        self.recipientVault = getAccount(recipient)
            .getCapability(/public/MyTokenVault)
            .borrow<&{FungibleToken.Receiver}>()
            ?? panic("Could not borrow receiver reference")
    }

    execute {
        self.recipientVault.deposit(from: <-self.senderVault.withdraw(amount: amount))
    }
}