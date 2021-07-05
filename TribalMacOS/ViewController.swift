//
//  ViewController.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 3.07.2021.
//

import AppKit
import SnapKit
import Nuke
import TribalCore

class ViewController: NSViewController {
    lazy var browserVC = BrowserViewController()
    
    override func loadView() {
        super.loadView()
        
        addChild(browserVC)
        view.addSubview(browserVC.view)
    }
    
    override func viewDidLayout() {
        super.viewDidLayout()
        browserVC.view.frame = view.bounds
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}
