import MyToken from 0x01
import FungibleToken from 0x9a0766d93b6608b7

transaction(recipient: Address, amount: UFix64) {
    let minter: &MyToken.Minter
    let recipientVault: &{FungibleToken.Receiver}

    prepare(signer: AuthAccount) {
        self.minter = signer.borrow<&MyToken.Minter>(from: /storage/MyTokenMinter)
            ?? panic("Could not borrow minter reference")
        self.recipientVault = getAccount(recipient)
            .getCapability(/public/MyTokenVault)
            .borrow<&{FungibleToken.Receiver}>()
            ?? panic("Could not borrow receiver reference")
    }

    execute {
        let mintedVault <- self.minter.mintTokens(amount: amount)
        self.recipientVault.deposit(from: <-mintedVault)
    }
}