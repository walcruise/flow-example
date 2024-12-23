import MyToken from 0x01
import FlowToken from 0x7e60df042a9c0868
import FungibleToken from 0x9a0766d93b6608b7

pub fun main(address: Address): {String: UFix64} {
    let account = getAccount(address)
    
    let myTokenBalance = account.getCapability(/public/MyTokenVault)
        .borrow<&MyToken.Vault{FungibleToken.Balance}>()?.balance
        ?? 0.0
    
    let flowBalance = account.getCapability(/public/flowTokenBalance)
        .borrow<&FlowToken.Vault{FungibleToken.Balance}>()?.balance
        ?? 0.0
    
    return {
        "MyToken": myTokenBalance,
        "FlowToken": flowBalance
    }
}