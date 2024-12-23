import MyToken from 0x01
import FungibleToken from 0x9a0766d93b6608b7

pub fun main(address: Address): UFix64 {
    let account = getAccount(address)
    
    if let vaultRef = account.getCapability(/public/MyTokenVault)
        .borrow<&{FungibleToken.Balance}>() {
        if vaultRef.isInstance(Type<@MyToken.Vault>()) {
            return vaultRef.balance
        }
    }
    
    if let vaultRef = account.getCapability(/public/MyTokenVault)
        .borrow<&AnyResource{FungibleToken.Balance}>() {
        if vaultRef.getType().identifier == "A.0000000000000001.MyToken.Vault" {
            return vaultRef.balance
        }
    }
    
    panic("Could not find a valid MyToken vault")
}