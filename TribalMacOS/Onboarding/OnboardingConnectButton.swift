//
//  OnboardingConnectButton.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 14.07.2021.
//

import AppKit

class OnboardingConnectButton: NSButton {
    let provider: AuthenticationProvider
    init(provider: AuthenticationProvider, title: String, target: AnyObject?, action: Selector?) {
        self.provider = provider
        super.init(frame: .zero)
        
        self.setButtonType(.momentaryPushIn)
        self.bezelStyle = .rounded
        self.title = title
        self.target = target
        self.action = action
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
