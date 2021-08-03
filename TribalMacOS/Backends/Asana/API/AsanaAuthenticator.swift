//
//  AsanaAuthenticator.swift
//  TribalMacOS
//
//  Created by Umur Gedik on 9.07.2021.
//

import Foundation
import AuthenticationServices

class AsanaAuthenticator: AuthenticationProvider {
    public let name: String = "Asana"
    public let presenter: Presenter
    public weak var delegate: AuthenticationProviderDelegate?
    
    init(presenter: Presenter) {
        self.presenter = presenter
    }
    
    func authenticate( _ completion: @escaping (Result<Account, AuthenticationError>) -> Void) {
        let name = self.name
        authenticate { (result: Result<AsanaAPICredentials, AuthenticationError>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let credentials):
                    do {
                        let data = try JSONEncoder().encode(credentials)
                        let account = Account(id: credentials.userMetadata.id, provider: name, credentials: data)
                        completion(.success(account))
                    } catch {
                        completion(.failure(.invalidPayload(error)))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func updateCredentials(_ credentials: AsanaAPICredentials, completion: @escaping (Result<AsanaAPICredentials, AuthenticationError>) -> Void) {
        func handleExchangeTokenResult(_ result: Result<AsanaAPICredentials, AuthenticationError>) {
            switch result {
            case let .success(credentials): completion(.success(credentials))
            case let .failure(.unsuccessful(statusCode, responseData?)):
                guard let json = try? JSONSerialization.jsonObject(with: responseData, options: []) as? [String: String] else {
                    completion(.failure(.unsuccessful(statusCode, responseData)))
                    return
                }
                
                if json["error"] == "invalid_grant" {
                    DispatchQueue.main.async {
                        self.authenticate(completion)
                    }
                } else {
                    completion(.failure(.unsuccessful(statusCode, responseData)))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
        
        exchangeToken(code: credentials.authorizationCode, refreshToken: credentials.refreshToken, completion: handleExchangeTokenResult(_:))
    }
    
    func authenticate(_ completion: @escaping (Result<AsanaAPICredentials, AuthenticationError>) -> Void) {
        getAuthorizationCode { result in
            switch result {
            case let .failure(error):
                completion(.failure(error))
                
            case let .success(code):
                self.exchangeToken(code: code, refreshToken: nil) { result in
                    switch result {
                    case let .success(credentials):
                        DispatchQueue.main.async {
                            let credentialsData = try! JSONEncoder().encode(credentials)
                            self.delegate?.authenticationProvider(self, didUpdateAccount: Account(id: credentials.userMetadata.id, provider: self.name, credentials: credentialsData))
                        }
                        completion(.success(credentials))
                        
                    default:
                        completion(result)
                    }
                }
            }
        }
    }
    
    private func getAuthorizationCode(_ completion: @escaping (Result<String, AuthenticationError>) -> Void) {
        let queryParams = [
            "client_id": "1200510601313711",
            "response_type": "code",
            "redirect_uri": "https://tribalmac.app/oauth/asana"
        ]
        
        let queryItems = queryParams.map(URLQueryItem.init(name:value:))
        var urlComponents = URLComponents(string: "https://app.asana.com/-/oauth_authorize")!
        urlComponents.queryItems = queryItems
        
        let url = urlComponents.url!
        let scheme = "tribal"
        
        let session = ASWebAuthenticationSession(url: url, callbackURLScheme: scheme) { callbackURL, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let url = callbackURL else {
                completion(.failure(.invalidPayload(nil)))
                return
            }
            
            guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
                  let codeQueryItem = components.queryItems?.first(where: { $0.name == "code" }),
                  let code = codeQueryItem.value
            else {
                completion(.failure(.invalidPayload(nil)))
                return
            }

            completion(.success(code))
        }

        session.presentationContextProvider = presenter
        session.prefersEphemeralWebBrowserSession = true
        session.start()
    }
    
    private func exchangeToken(code: String, refreshToken: String?, completion: @escaping (Result<AsanaAPICredentials, AuthenticationError>) -> Void) {
        var queryParams = [
            "grant_type": "authorization_code",
            "client_id": "1200510601313711",
            "client_secret": "5a83e285d9037ba718a0693e0a419a2d",
            "redirect_uri": "https://tribalmac.app/oauth/asana",
            "code": code,
        ]
        
        if let refreshToken = refreshToken {
            queryParams["refresh_token"] = refreshToken
        }
        
        var urlComponents = URLComponents(string: "https://app.asana.com/-/oauth_token")!
        urlComponents.queryItems = queryParams.map(URLQueryItem.init(name:value:))
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: request) { maybeData, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  let data = maybeData
            else {
                completion(.failure(.invalidPayload(nil)))
                return
            }
            
            guard response.statusCode == 200 else {
                completion(.failure(.unsuccessful(response.statusCode, data)))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let response = try decoder.decode(ExchangeTokenResponse.self, from: data)
                completion(.success(AsanaAPICredentials(from: response, code: code)))
            } catch {
                let error = error
                completion(.failure(.invalidPayload(error)))
            }
        }.resume()
    }
}

fileprivate struct ExchangeTokenResponse: Codable {
    let accessToken: String
    let expiresIn: Int
    let tokenType: String
    let refreshToken: String
    let data: Data
    
    struct Data: Codable {
        public let id: Int
        public let name: String
        public let email: String
    }
}

fileprivate extension AsanaAPICredentials {
    init(from response: ExchangeTokenResponse, code: String) {
        authorizationCode = code
        accessToken = response.accessToken
        expiresIn = response.expiresIn
        tokenType = response.tokenType
        refreshToken = response.refreshToken
        
        let data = response.data
        userMetadata = AsanaAPICredentials.UserMetadata(id: String(data.id), name: data.name, email: data.email)
        createdAt = Date()
    }
}
