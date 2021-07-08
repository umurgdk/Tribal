//
//  Profile.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 8.07.2021.
//

import Foundation

public class Profile {
    public let id = UUID()
    public let name: String
    public let imageURL: URL?
    
    public init(name: String, imageURL: URL?) {
        self.name = name
        self.imageURL = imageURL
    }
}

