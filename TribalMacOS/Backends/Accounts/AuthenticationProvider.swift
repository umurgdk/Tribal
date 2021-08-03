//
//  AuthenticationProvider.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 14.07.2021.
//

import AppKit
import AuthenticationServices

public protocol AuthenticationProviderDelegate: AnyObject {
    func authenticationProvider(_ provider: AuthenticationProvider, didUpdateAccount account: Account)
}

public protocol AuthenticationProvider: AnyObject {
    typealias Presenter = ASWebAuthenticationPresentationContextProviding
    typealias Delegate = AuthenticationProviderDelegate
    
    var name: String { get }
    var delegate: Delegate? { get set }
    func authenticate(_ completion: @escaping (Result<Account, AuthenticationError>) -> Void)
}
