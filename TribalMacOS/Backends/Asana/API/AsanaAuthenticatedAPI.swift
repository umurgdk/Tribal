//
//  AsanaAuthenticatedAPI.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 18.07.2021.
//

import Foundation

enum AsanaAPIError: LocalizedError {
    case networkError(Error)
    case unexpectedResponse(URLResponse, Data?)
    case invalidPayload(Data?, Error)
    case authenticationError(AuthenticationError)
    
    var errorDescription: String? {
        switch self {
        case .networkError(let error):
            return "Asana API Error: \(error.localizedDescription)"
            
        case .unexpectedResponse(let response, _):
            let statusCode = (response as? HTTPURLResponse).map { String($0.statusCode) } ?? "N/A"
            return "Asana API Error: Unexpected response, statusCode: \(statusCode)"
        case let .invalidPayload(data?, error):
            let payload = String(data: data, encoding: .utf8) ?? "N/A"
            return "Asana API Error: Invalid payload: \(error.localizedDescription), payload is: \(payload)"
        case let .invalidPayload(_, error):
            return "Asana API Error: Invalid payload: \(error.localizedDescription)"
            
        case let .authenticationError(error):
            return "Asana API Error: authentication failed with: \(error.localizedDescription)"
        }
    }
}

class AsanaAuthenticatedAPI {
    var credentials: AsanaAPICredentials
    let authenticator: AsanaAuthenticator
    let urlSession: URLSession
    init(credentials: AsanaAPICredentials, authenticator: AsanaAuthenticator, urlSession: URLSession = .shared) {
        self.credentials = credentials
        self.urlSession = urlSession
        self.authenticator = authenticator
    }
    
    private var authenticationHeaders: [String: String] {
        ["Authorization": "Bearer \(credentials.accessToken)"]
    }
    
    private func ensureCredentials(_ completionHandler: @escaping (AuthenticationError?) -> Void) {
        if credentials.isExpired {
            authenticator.updateCredentials(credentials) { result in
                switch result {
                case .success(let newCredentials):
                    self.credentials = newCredentials
                    completionHandler(nil)
                case .failure(let error):
                    completionHandler(error)
                }
            }
        } else {
            completionHandler(nil)
        }
    }
    
    func fetchAuthenticatedUser(_ completionHandler: @escaping (Result<AsanaUser, AsanaAPIError>) -> Void) {
        ensureCredentials { [self] error in
            if let error = error {
                completionHandler(.failure(.authenticationError(error)))
                return
            }
         
            let meURL = URL(string: "https://app.asana.com/api/1.0/users/me")!
            var request = URLRequest(url: meURL, cachePolicy: .reloadRevalidatingCacheData)
            request.allHTTPHeaderFields = authenticationHeaders
            urlSession.dataTask(with: request) { maybeData, response, error in
                if let error = error {
                    completionHandler(.failure(.networkError(error)))
                    return
                }
                
                guard
                    let httpResponse = response as? HTTPURLResponse,
                    200..<400 ~= httpResponse.statusCode,
                    let data = maybeData
                else {
                    completionHandler(.failure(.unexpectedResponse(response!, maybeData)))
                    return
                }
                
                do {
                    let user = try JSONDecoder().decode(AsanaUser.self, from: data)
                    completionHandler(.success(user))
                } catch {
                    completionHandler(.failure(.invalidPayload(data, error)))
                }
            }.resume()
        }
    }
}
