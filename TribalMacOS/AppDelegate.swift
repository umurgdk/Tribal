//
//  AppDelegate.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 3.07.2021.
//

import AppKit
import KeychainSwift

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    static var shared: AppDelegate {
        NSApp.delegate as! AppDelegate
    }
    
    let keychain = KeychainSwift(keyPrefix: "tribal")
    lazy var accountsController = AccountsController(keychain: keychain)
    lazy var backends: [String: Backend] = [
        "Asana": Asana(authenticationPresenter: self)
    ]
    
    lazy var authProviders: [AuthenticationProvider] = backends.values.map { backend in
        backend.authenticationProvider.delegate = self
        return backend.authenticationProvider
    }
    
    var entityContexts: [EntityContext] = []
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        accountsController.delegate = self
        let accounts = try! accountsController.loadAccounts()
        entityContexts = try! accounts.map { account in
            let entityContext = try backends[account.provider]!.createEntityContext(account: account)
            return entityContext
        }
        
        let contextBrowserWC = ContextBrowserWindowController.create { [unowned self] in
            let vc = OnboardingViewController(authenticationProviders: self.authProviders)
            vc.delegate = self
            return vc
        }
        
        contextBrowserWC.contexts = entityContexts
        WindowCoordinator.shared.add(contextBrowserWC)
        contextBrowserWC.showWindow(self)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

extension AppDelegate: AccountsControllerDelegate {
    func accountsControllerDidAddAccount(_ account: Account) {
        let context = try! backends[account.provider]!.createEntityContext(account: account)
        entityContexts.append(context)
        WindowCoordinator.shared.contextBrowserWindowControllers.forEach { windowController in
            windowController.contexts = entityContexts
        }
    }
}

extension AppDelegate: OnboardingDelegate {
    func onboardingDidRequestAuthentication(with provider: AuthenticationProvider) {
        guard let backend = backends.values.first(where: { $0.authenticationProvider === provider }) else { return }
        
        backend.authenticationProvider.authenticate { result in
            if case let .failure(error) = result {
                NSAlert(error: error).runModal()
            }
        }
    }
}

import AuthenticationServices
extension AppDelegate: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        WindowCoordinator.shared.windowControllers[0].window!
    }
}

extension AppDelegate: AuthenticationProviderDelegate {
    func authenticationProvider(_ provider: AuthenticationProvider, didUpdateAccount account: Account) {
        try! accountsController.addAccount(account)
    }
}
