import MyToken from 0x01
import FungibleToken from 0x9a0766d93b6608b7

pub fun main(address: Address): Bool {
    let account = getAccount(address)
    let vaultRef = account.getCapability(/public/MyTokenVault)
        .borrow<&MyToken.Vault{FungibleToken.Receiver, FungibleToken.Balance}>()
    
    return vaultRef != nil
}