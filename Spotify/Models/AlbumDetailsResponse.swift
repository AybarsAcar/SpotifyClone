//
//  AlbumDetailsResponse.swift
//  Spotify
//
//  Created by Aybars Acar on 12/2/2022.
//

import Foundation

struct AlbumDetailsResponse: Codable {
  let albumType: String
  let artists: [Artist]
  let availableMarkets: [String]
  let externalUrls: [String: String]
  let href: String
  let id: String
  let images: [APIImage]
  let label, name: String
  let popularity: Int
  let releaseDate, releaseDatePrecision: String
  let totalTracks: Int
  let tracks: TracksResponse
  let type, uri: String
  
  enum CodingKeys: String, CodingKey {
    case albumType = "album_type"
    case artists
    case availableMarkets = "available_markets"
    case externalUrls = "external_urls"
    case href, id, images, label, name, popularity
    case releaseDate = "release_date"
    case releaseDatePrecision = "release_date_precision"
    case totalTracks = "total_tracks"
    case tracks, type, uri
  }
}

struct TracksResponse: Codable {
  let href: String
  let items: [AudioTrack]
  let total: Int
}
