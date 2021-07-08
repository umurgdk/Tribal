//
//  Observation.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 8.07.2021.
//

import Foundation

class ObservationBag {
    private var observations: [NSKeyValueObservation] = []
    
    public func observeNew<S: NSObject, T>(_ keyPath: ReferenceWritableKeyPath<S, T>, in observer: S, withInitialValue: Bool = false, _ changeHandler: @escaping (S, T) -> Void) {
        var options: NSKeyValueObservingOptions = [.new]
        if withInitialValue {
            options.insert(.initial)
        }
        
        weak var weakObserver = observer
        let observation = observer.observe(keyPath, options: options) { _, change in
            guard let observer = weakObserver else { return }
            changeHandler(observer, change.newValue!)
        }
        
        observations.append(observation)
    }
}
