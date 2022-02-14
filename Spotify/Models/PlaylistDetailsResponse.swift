//
//  PlaylistDetailsResponse.swift
//  Spotify
//
//  Created by Aybars Acar on 12/2/2022.
//

import Foundation

struct PlaylistDetailsResponse: Codable {
  
  let href: String
  let externalUrls: [String: String]
  let collaborative: Bool
  let description: String
  let images: [APIImage]
  let id: String
  let owner: Owner
  let primaryColor: String?
  let playlistResponsePublic: Bool
  let snapshotID: String
  let tracks: PlaylistTracksResponse
  let type, uri: String
  let followers: Followers
  let name: String
  
  enum CodingKeys: String, CodingKey {
    case collaborative
    case description
    case externalUrls = "external_urls"
    case followers, href, id, images, name, owner
    case primaryColor = "primary_color"
    case playlistResponsePublic = "public"
    case snapshotID = "snapshot_id"
    case tracks, type, uri
  }
}

struct Followers: Codable {
  let href: String?
  let total: Int
}

struct PlaylistTracksResponse: Codable {
  let items: [PlaylistItem]
}

struct PlaylistItem: Codable {
  let track: AudioTrack
}
