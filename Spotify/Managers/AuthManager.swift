//
//  AuthManager.swift
//  Spotify
//
//  Created by Aybars Acar on 9/2/2022.
//

import Foundation

final class AuthManager {
  
  static let shared = AuthManager()
  private init() { }
  
  private var refreshingToken: Bool = false
  
  struct Constants {
    static let clientID = Bundle.main.object(forInfoDictionaryKey: "client_id") as! String
    static let clientSecret = Bundle.main.object(forInfoDictionaryKey: "client_secret") as! String
    static let tokenAPIURL = "https://accounts.spotify.com/api/token"
    static let redirectURI = "https://iosacademy.io"
    static let scopes = "user-read-private%20playlist-modify-public%20playlist-read-private%20playlist-modify-private%20user-follow-read%20user-library-modify%20user-library-read%20user-read-email"
  }
  
  public var signInURL: URL? {
    let base = "https://accounts.spotify.com/authorize"
    
    let string = "\(base)?response_type=code&client_id=\(Constants.clientID)&scope=\(Constants.scopes)&redirect_uri=\(Constants.redirectURI)&show_dialog=TRUE"
    
    return URL(string: string)
  }
  
  var isSignedIn: Bool {
    return accessToken != nil
  }
  
  
  /// Exchange the code with a token via a POST request
  func exchangeCodeForToken(code: String, completion: @escaping (Bool) -> Void) {
    // Get Token
    guard let url = URL(string: Constants.tokenAPIURL) else { return }
    
    var components = URLComponents()
    components.queryItems = [
      URLQueryItem(name: "grant_type", value: "authorization_code"),
      URLQueryItem(name: "code", value: code),
      URLQueryItem(name: "redirect_uri", value: Constants.redirectURI)
    ]
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.httpBody = components.query?.data(using: .utf8)
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    
    let basicToken = Constants.clientID + ":" + Constants.clientSecret
    let data = basicToken.data(using: .utf8)
    let base64String = data?.base64EncodedString()
    guard let base64String = base64String else {
      print("Failure to get base64 String")
      completion(false)
      return
    }
    
    request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
    
    let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
      guard let data = data, error == nil else {
        completion(false)
        return
      }
      
      do {
        let result = try JSONDecoder().decode(AuthResponse.self, from: data)
        
        self?.cacheToken(result: result)
        
        completion(true)
        
      } catch {
        completion(false)
        print(error.localizedDescription)
      }
    }
    
    task.resume()
  }
  
  private var onRefreshBlocks = [(String) -> Void]()
  
  /// completion handler gives the access token back and takes at a param
  /// supplies valied token to be used with API calls so we have the token available to us in each call
  func withValidToken(completion: @escaping (String) -> Void) {
    
    guard !refreshingToken else {
      // append the completion
      onRefreshBlocks.append(completion)
      
      return
    }
    
    if shouldRefreshToken {
      refreshIfNeeded { [weak self] success in
        if success, let token = self?.accessToken {
          completion(token)
        }
      }
    }
    
    else if let token = accessToken {
      completion(token)
    }
  }
  
  func refreshIfNeeded(completion: ((Bool) -> Void)?) {
    guard !refreshingToken else { return }
    
    guard shouldRefreshToken else {
      completion?(true)
      return
    }
    
    guard let refreshToken = self.refreshToken else { return }
    
    // REFRESH THE TOKEN
    guard let url = URL(string: Constants.tokenAPIURL) else { return }
    
    refreshingToken = true
    
    var components = URLComponents()
    components.queryItems = [
      URLQueryItem(name: "grant_type", value: "refresh_token"),
      URLQueryItem(name: "refresh_token", value: refreshToken)
    ]
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.httpBody = components.query?.data(using: .utf8)
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    
    let basicToken = Constants.clientID + ":" + Constants.clientSecret
    let data = basicToken.data(using: .utf8)
    let base64String = data?.base64EncodedString()
    guard let base64String = base64String else {
      print("Failure to get base64 String")
      completion?(false)
      return
    }
    
    request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
    
    let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
      
      self?.refreshingToken = false
      
      guard let data = data, error == nil else {
        completion?(false)
        return
      }
      
      do {
        let result = try JSONDecoder().decode(AuthResponse.self, from: data)
        
        self?.onRefreshBlocks.forEach({ $0(result.access_token) })
        self?.onRefreshBlocks.removeAll()
        
        print("Successfully refreshed")
        
        self?.cacheToken(result: result)
        
        completion?(true)
        
      } catch {
        completion?(false)
        print(error.localizedDescription)
      }
    }
    
    task.resume()
  }
  
  /// we will be caching everything to USerDefaults.standard
  private func cacheToken(result: AuthResponse) {
    UserDefaults.standard.setValue(result.access_token, forKey: "access_token")
    
    if let refreshToken = result.refresh_token {
      UserDefaults.standard.setValue(refreshToken, forKey: "refresh_token")
    }
    
    UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in)), forKey: "expirationDate")
  }
  
  private var accessToken: String? {
    return UserDefaults.standard.string(forKey: "access_token")
  }
  
  private var refreshToken: String? {
    return UserDefaults.standard.string(forKey: "refresh_token")
  }
  
  private var tokenExpirationDate: Date? {
    return UserDefaults.standard.object(forKey: "expirationDate") as? Date
  }
  
  /// refresh the token when there a couple minutes left for our valid token
  /// we will do when 5 mins left to expuration
  private var shouldRefreshToken: Bool {
    guard let expirationDate = tokenExpirationDate else { return false }
    
    let currentDate = Date()
    let fiveMinutes: TimeInterval = 300
    
    return currentDate.addingTimeInterval(fiveMinutes) >= expirationDate
  }
}
