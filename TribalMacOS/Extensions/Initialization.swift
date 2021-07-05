//
//  Initialization.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 3.07.2021.
//

import Foundation

protocol Configurable: AnyObject { }

extension Configurable {
    func configure(_ block: (Self) -> Void) -> Self {
        block(self)
        return self
    }
}

extension NSObject: Configurable { }
