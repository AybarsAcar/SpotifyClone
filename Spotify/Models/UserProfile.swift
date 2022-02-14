//
//  UserProfile.swift
//  Spotify
//
//  Created by Aybars Acar on 9/2/2022.
//

import Foundation

struct UserProfile: Codable {
  let country: String
  let displayName: String
  let email: String
  let explicitContent: [String: Bool]
  let externalURLs: [String: String]
  let id: String
  let product: String
  let images: [APIImage]
  
  enum CodingKeys: String, CodingKey {
    case displayName = "display_name"
    case explicitContent = "explicit_content"
    case externalURLs = "external_urls"
    case country, email, id, product, images
  }
}
