//
//  AccountsController.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 14.07.2021.
//

import Foundation
import KeychainSwift

protocol AccountsControllerDelegate: AnyObject {
    func accountsControllerDidAddAccount(_ account: Account)
}

class AccountsController {
    public weak var delegate: AccountsControllerDelegate?
    
    public let keychain: KeychainSwift
    public init(keychain: KeychainSwift = .init()) {
        self.keychain = keychain
    }
    
    public private(set) var accounts: [Account] = []
    
    public func addAccount(_ account: Account) throws {
        var accounts = (try? loadAccounts()) ?? []
        accounts = accounts.filter { $0.id != account.id && $0.provider != account.provider }
        accounts.append(account)
        
        let data = try JSONEncoder().encode(accounts)
        keychain.set(data, forKey: "accounts")
        self.accounts = accounts
    }
    
    public func loadAccounts() throws -> [Account] {
        guard let accountData = keychain.getData("accounts") else { return [] }
        let accounts = try JSONDecoder().decode([Account].self, from: accountData)
        self.accounts = accounts
        return accounts
    }
}
