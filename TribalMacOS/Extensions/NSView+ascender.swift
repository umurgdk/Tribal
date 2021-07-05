//
//  NSView+ascender.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 3.07.2021.
//

import AppKit

extension NSView {
    func ascender<T: NSView>(of viewClass: T.Type = T.self) -> T? {
        var view: NSView? = self
        while let parent = view {
            if parent.isKind(of: T.self) {
                return (parent as! T)
            }
            
            view = parent.superview
        }
        
        return nil
    }
}
