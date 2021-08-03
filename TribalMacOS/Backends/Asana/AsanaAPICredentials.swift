//
//  AsanaAPICredentials.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 9.07.2021.
//

import Foundation

public struct AsanaAPICredentials: Codable, Hashable {
    public let authorizationCode: String
    public let accessToken: String
    public let expiresIn: Int
    public let tokenType: String
    public let refreshToken: String
    public let userMetadata: UserMetadata
    public let createdAt: Date
    
    public struct UserMetadata: Codable, Hashable {
        public let id: String
        public let name: String
        public let email: String
    }
    
    var isExpired: Bool {
        createdAt.addingTimeInterval(TimeInterval(expiresIn)) < Date()
    }
}
