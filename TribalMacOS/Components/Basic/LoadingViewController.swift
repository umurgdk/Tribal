//
//  LoadingViewController.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 18.07.2021.
//

import AppKit

class LoadingViewController: BaseViewController {
    override func loadView() {
        view = NSView()
        
        let progressIndicator = NSProgressIndicator().configure {
            $0.style = .spinning
            $0.isIndeterminate = true
            $0.startAnimation(nil)
        }
        
        view.addSubview(progressIndicator)
        
        progressIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
