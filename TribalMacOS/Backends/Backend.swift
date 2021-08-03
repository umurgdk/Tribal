//
//  Backend.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 18.07.2021.
//

import Foundation

public protocol Backend {
    var authenticationProvider: AuthenticationProvider { get }
    func createEntityContext(account: Account) throws -> AsanaEntityContext
}
