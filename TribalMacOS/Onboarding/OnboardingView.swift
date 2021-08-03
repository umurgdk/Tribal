//
//  OnboardingView.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 14.07.2021.
//

import AppKit

class OnboardingView: BaseView {
    let stackView = NSStackView().configure {
        $0.orientation = .vertical
        $0.alignment = .width
    }
    
    let welcomeLabel = NSTextField(labelWithString: "Tribal").configure {
        $0.font = .preferredFont(forTextStyle: .largeTitle, options: [:])
    }
    
    override func setupViewHierarchy() {
        addSubview(stackView)
        stackView.addArrangedSubview(welcomeLabel)
        stackView.snp.makeConstraints { make in
            make.width.height.lessThanOrEqualToSuperview()
            make.center.equalToSuperview()
        }
    }
    
    public func addConnectButton(_ view: NSView) {
        stackView.addArrangedSubview(view)
    }
}
