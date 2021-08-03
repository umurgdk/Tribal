//
//  AuthenticationViewController.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 9.07.2021.
//

import AppKit
import AuthenticationServices

class AuthenticationViewController: NSViewController {
    lazy var authButton = NSButton(title: "Authorize Asana Account", target: self, action: #selector(didClickAuthorizeButton))
    override func loadView() {
        view = NSView()
        preferredContentSize = NSSize(width: 400, height: 400)
        view.addSubview(authButton)
        
        authButton.sizeToFit()
    }
    
    override func viewDidLayout() {
        super.viewDidLayout()
        
        let authOrigin = NSPoint(
            x: view.bounds.midX - authButton.bounds.midX,
            y: view.bounds.midY - authButton.bounds.midY
        )
        
        authButton.setFrameOrigin(authOrigin)
    }
    
    @objc func didClickAuthorizeButton(_ sender: NSButton) {
        let queryParams = [
            "client_id": "1200510601313711",
            "response_type": "code",
            "redirect_uri": "https://tribalmac.app/oauth/asana"
        ]
        
        let queryItems = queryParams.map(URLQueryItem.init(name:value:))
        var urlComponents = URLComponents(string: "https://app.asana.com/-/oauth_authorize")!
        urlComponents.queryItems = queryItems
        
        let url = urlComponents.url!
        let scheme = "tribal"
        
        let session = ASWebAuthenticationSession(url: url, callbackURLScheme: "tribal") { callbackURL, error in
            if let error = error {
                NSAlert(error: error).runModal()
            }
            
            guard let url = callbackURL else {
                fatalError("AppKit is broken")
            }
            
            guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
                  let codeQueryItem = components.queryItems?.first(where: { $0.name == "code" }),
                  let code = codeQueryItem.value
            else {
                NSAlert().configure {
                    $0.messageText = "Failed to connect to Asana"
                }.runModal()
                return
            }
            
            print("Authorization code is:", code)
        }
        session.presentationContextProvider = self
        session.prefersEphemeralWebBrowserSession = true
        session.start()
    }
}

extension AuthenticationViewController: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        view.window!
    }
}
