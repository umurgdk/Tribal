//
//  Asana.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 14.07.2021.
//

import Foundation

class Asana: Backend {
    let authenticationPresenter: AuthenticationProvider.Presenter
    let authenticationProvider: AuthenticationProvider
    init(authenticationPresenter: AuthenticationProvider.Presenter) {
        self.authenticationPresenter = authenticationPresenter
        self.authenticationProvider = AsanaAuthenticator(presenter: authenticationPresenter)
    }
    
    public func createEntityContext(account: Account) throws -> AsanaEntityContext {
        let asanaAPICredentials = try JSONDecoder().decode(AsanaAPICredentials.self, from: account.credentials)
        let authenticatedAPI = AsanaAuthenticatedAPI(credentials: asanaAPICredentials, authenticator: authenticationProvider as! AsanaAuthenticator)
        return AsanaEntityContext(api: authenticatedAPI)
    }
}
