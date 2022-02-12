//
//  AudioTrack.swift
//  Spotify
//
//  Created by Aybars Acar on 9/2/2022.
//

import Foundation


struct AudioTrack: Codable {
  let album: Album
  let artists: [Artist]
  let availableMarkets: [String]
  let discNumber, durationMS: Int
  let explicit: Bool
  let externalIDS: [String: String]
  let externalUrls: [String: String]
  let href: String
  let id: String
  let isLocal: Bool
  let name: String
  let popularity: Int
  let previewURL: String?
  let trackNumber: Int
  let type: String
  let uri: String
  
  enum CodingKeys: String, CodingKey {
    case album, artists
    case availableMarkets = "available_markets"
    case discNumber = "disc_number"
    case durationMS = "duration_ms"
    case explicit
    case externalIDS = "external_ids"
    case externalUrls = "external_urls"
    case href, id
    case isLocal = "is_local"
    case name, popularity
    case previewURL = "preview_url"
    case trackNumber = "track_number"
    case type, uri
  }
}
