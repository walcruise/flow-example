import MyToken from 0x01
import FungibleToken from 0x9a0766d93b6608b7

transaction {
    prepare(signer: AuthAccount) {
        if let vault = signer.borrow<&MyToken.Vault>(from: /storage/MyTokenVault) {
            if !signer.getCapability(/public/MyTokenVault).check<&MyToken.Vault{FungibleToken.Receiver, FungibleToken.Balance}>() {
                signer.unlink(/public/MyTokenVault)
                signer.link<&MyToken.Vault{FungibleToken.Receiver, FungibleToken.Balance}>(/public/MyTokenVault, target: /storage/MyTokenVault)
            }
        } else {
            signer.save(<-MyToken.createEmptyVault(), to: /storage/MyTokenVault)
            signer.link<&MyToken.Vault{FungibleToken.Receiver, FungibleToken.Balance}>(/public/MyTokenVault, target: /storage/MyTokenVault)
        }
    }
}