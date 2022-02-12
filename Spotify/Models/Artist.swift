//
//  Artist.swift
//  Spotify
//
//  Created by Aybars Acar on 9/2/2022.
//

import Foundation

struct Artist: Codable {
  let externalUrls: [String: String]
  let href: String
  let id, name, type, uri: String
  
  enum CodingKeys: String, CodingKey {
    case externalUrls = "external_urls"
    case href, id, name, type, uri
  }
}
