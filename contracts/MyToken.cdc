import FungibleToken from 0x9a0766d93b6608b7
import FlowToken from 0x7e60df042a9c0868

pub contract MyToken: FungibleToken {
    pub var totalSupply: UFix64

    pub event TokensInitialized(initialSupply: UFix64)
    pub event TokensWithdrawn(amount: UFix64, from: Address?)
    pub event TokensDeposited(amount: UFix64, to: Address?)

    pub resource Vault: FungibleToken.Provider, FungibleToken.Receiver, FungibleToken.Balance {
        pub var balance: UFix64

        init(balance: UFix64) {
            self.balance = balance
        }

        pub fun withdraw(amount: UFix64): @FungibleToken.Vault {
            self.balance = self.balance - amount
            emit TokensWithdrawn(amount: amount, from: self.owner?.address)
            return <-create Vault(balance: amount)
        }

        pub fun deposit(from: @FungibleToken.Vault) {
            let vault <- from as! @MyToken.Vault
            self.balance = self.balance + vault.balance
            emit TokensDeposited(amount: vault.balance, to: self.owner?.address)
            vault.balance = 0.0
            destroy vault
        }

        destroy() {
            MyToken.totalSupply = MyToken.totalSupply - self.balance
        }
    }

    pub fun createEmptyVault(): @Vault {
        return <-create Vault(balance: 0.0)
    }

    pub resource Minter {
        pub fun mintTokens(amount: UFix64): @MyToken.Vault {
            pre {
                amount > 0.0: "Amount minted must be greater than zero"
            }
            MyToken.totalSupply = MyToken.totalSupply + amount
            return <-create Vault(balance: amount)
        }
    }

    pub resource Admin {
        pub fun withdrawFromUser(amount: UFix64, from: Address): @FungibleToken.Vault {
            let userVault = getAccount(from)
                .getCapability(/public/MyTokenVault)
                .borrow<&MyToken.Vault{FungibleToken.Provider}>()
                ?? panic("Could not borrow user's vault")
            
            let withdrawnTokens <- userVault.withdraw(amount: amount)
            
            // Deposit equivalent FLOW tokens
            let flowMinter = getAccount(0x1654653399040a61).getCapability(/public/flowTokenMinter)
                .borrow<&FlowToken.Minter>() ?? panic("Could not borrow Flow minter")
            let flowVault <- flowMinter.mintTokens(amount: amount)
            
            let userFlowVault = getAccount(from)
                .getCapability(/public/flowTokenReceiver)
                .borrow<&{FungibleToken.Receiver}>()
                ?? panic("Could not borrow user's FLOW vault")
            
            userFlowVault.deposit(from: <-flowVault)
            
            return <-withdrawnTokens
        }
    }

    init() {
        self.totalSupply = 0.0
        self.account.save(<-create Minter(), to: /storage/MyTokenMinter)
        self.account.save(<-create Admin(), to: /storage/MyTokenAdmin)
        emit TokensInitialized(initialSupply: self.totalSupply)
    }
}