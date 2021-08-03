//
//  OnboardingViewController.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 14.07.2021.
//

import AppKit

protocol OnboardingDelegate: AnyObject {
    func onboardingDidRequestAuthentication(with provider: AuthenticationProvider)
}

class OnboardingViewController: BaseViewController {
    public let authenticationProviders: [AuthenticationProvider]
    public weak var delegate: OnboardingDelegate?
    
    public init(authenticationProviders: [AuthenticationProvider]) {
        self.authenticationProviders = authenticationProviders
        super.init()
    }
    
    private lazy var onboardingView = OnboardingView()
    public override func loadView() {
        view = onboardingView
        
        for provider in authenticationProviders {
            let connectButton = OnboardingConnectButton(provider: provider, title: "Connect with \(provider.name)", target: self, action: #selector(didClickConnect(_:)))
            onboardingView.addConnectButton(connectButton)
        }
    }
    
    @objc private func didClickConnect(_ sender: OnboardingConnectButton) {
        delegate?.onboardingDidRequestAuthentication(with: sender.provider)
    }
}
