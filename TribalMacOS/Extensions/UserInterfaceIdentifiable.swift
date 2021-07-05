//
//  UserInterfaceIdentifiable.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 3.07.2021.
//

import AppKit

protocol UserInterfaceIdentifiable { }

extension UserInterfaceIdentifiable {
    static var userInterfaceIdentifier: NSUserInterfaceItemIdentifier {
        .init(String(describing: Self.self))
    }
}

extension NSTableView {
    func makeView<T: NSView>(_ cellClass: T.Type = T.self, owner: AnyObject?, initializer: () -> T = { T() }) -> T where T: UserInterfaceIdentifiable {
        if let cellView = makeView(withIdentifier: T.userInterfaceIdentifier, owner: owner) as? T {
            return cellView
        }
        
        return initializer().configure { $0.identifier = T.userInterfaceIdentifier }
    }
}

extension NSCollectionView {
    func register<T: NSCollectionViewItem>(_ itemClass: T.Type = T.self) where T: UserInterfaceIdentifiable {
        register(T.self, forItemWithIdentifier: T.userInterfaceIdentifier)
    }
    
    func registerSupplementary<T: NSView>(_ itemClass: T.Type = T.self, kind: NSCollectionView.SupplementaryElementKind) where T: UserInterfaceIdentifiable {
        register(T.self, forSupplementaryViewOfKind: kind, withIdentifier: T.userInterfaceIdentifier)
    }

    func makeItem<T: NSCollectionViewItem>(_ itemClass: T.Type = T.self, for indexPath: IndexPath) -> T where T: UserInterfaceIdentifiable {
        makeItem(withIdentifier: T.userInterfaceIdentifier, for: indexPath) as! T
    }
    
    func makeSupplementary<T: NSView>(_ itemClass: T.Type = T.self, ofKind kind: NSCollectionView.SupplementaryElementKind, for indexPath: IndexPath) -> T where T: UserInterfaceIdentifiable {
        makeSupplementaryView(ofKind: kind, withIdentifier: T.userInterfaceIdentifier, for: indexPath) as! T
    }
}
