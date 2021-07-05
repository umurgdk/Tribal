//
//  Divider.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 4.07.2021.
//

import AppKit

extension NSBox {
    static func divider() -> Background {
        Background().configure {
            $0.backgroundColor = .separatorColor
        }
        // NSBox().configure {
        //     $0.boxType = .custom
        //     $0.borderWidth = 0
        //     $0.fillColor = .separatorColor
        //     // $0.isTransparent = true
        // }
    }
}
