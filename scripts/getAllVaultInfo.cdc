import FungibleToken from 0x9a0766d93b6608b7

pub fun main(address: Address): [AnyStruct] {
    let account = getAccount(address)
    let vaultInfo: [AnyStruct] = []

    account.forEachStored(fun (path: StoragePath, type: Type): Bool {
        if type.isSubtype(of: Type<@FungibleToken.Vault>()) {
            if let vault = account.borrow<&{FungibleToken.Balance}>(from: path) {
                vaultInfo.append({
                    "path": path,
                    "type": type.identifier,
                    "balance": vault.balance
                })
            }
        }
        return true
    })

    return vaultInfo
}