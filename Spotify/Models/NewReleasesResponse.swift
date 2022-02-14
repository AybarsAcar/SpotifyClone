//
//  NewReleasesResponse.swift
//  Spotify
//
//  Created by Aybars Acar on 12/2/2022.
//

import Foundation

struct NewReleasesResponse: Codable {
  let albums: AlbumsResponse
}

struct AlbumsResponse: Codable {
  let items: [Album]
}

struct Album: Codable {
  let albumType: String
  let artists: [Artist]
  let availableMarkets: [String]
  let href: String
  let id: String
  let images: [APIImage]
  let name, releaseDate, releaseDatePrecision: String
  let totalTracks: Int
  let type, uri: String
  
  enum CodingKeys: String, CodingKey {
    case albumType = "album_type"
    case artists
    case availableMarkets = "available_markets"
    case href, id, name, images
    case releaseDate = "release_date"
    case releaseDatePrecision = "release_date_precision"
    case totalTracks = "total_tracks"
    case type, uri
  }
}
