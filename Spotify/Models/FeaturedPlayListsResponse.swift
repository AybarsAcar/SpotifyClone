//
//  FeaturedPlaylistsResponse.swift
//  Spotify
//
//  Created by Aybars Acar on 12/2/2022.
//

import Foundation

// MARK: - Response
struct FeaturedPlaylistsResponse: Codable {
  let message: String?
  let playlists: PlaylistsResponse
}

struct CategoryPlaylistsResponse: Codable {
  let playlists: PlaylistsResponse
}

// MARK: - Playlists
struct PlaylistsResponse: Codable {
  let items: [Playlist]
}


// MARK: - Owner
struct Owner: Codable {
  let displayName: String
  let externalUrls: [String: String]
  let href: String
  let id: String
  let type: StringLiteralType
  let uri: String
  
  enum CodingKeys: String, CodingKey {
    case displayName = "display_name"
    case externalUrls = "external_urls"
    case href, id, type, uri
  }
}


// MARK: - Tracks
struct Tracks: Codable {
  let href: String
  let total: Int
}

enum ItemType: String, Codable {
  case playlist = "playlist"
}
