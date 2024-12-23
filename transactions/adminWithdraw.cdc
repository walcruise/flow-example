import MyToken from 0x01

transaction(amount: UFix64, userAddress: Address) {
    let adminRef: &MyToken.Admin
    
    prepare(admin: AuthAccount) {
        self.adminRef = admin.borrow<&MyToken.Admin>(from: /storage/MyTokenAdmin)
            ?? panic("Could not borrow admin reference")
    }
    
    execute {
        let withdrawnTokens <- self.adminRef.withdrawFromUser(amount: amount, from: userAddress)
        destroy withdrawnTokens
    }
}