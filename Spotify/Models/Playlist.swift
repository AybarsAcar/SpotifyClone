//
//  Playlist.swift
//  Spotify
//
//  Created by Aybars Acar on 9/2/2022.
//

import Foundation


struct Playlist: Codable {
  let collaborative: Bool
  let itemDescription: String
  let externalUrls: [String: String]
  let href: String
  let id: String
  let images: [APIImage]
  let name: String
  let owner: Owner
  let snapshotID: String
  let tracks: Tracks
  let type: ItemType
  let uri: String
  
  enum CodingKeys: String, CodingKey {
    case collaborative
    case itemDescription = "description"
    case externalUrls = "external_urls"
    case href, id, images, name, owner
    case snapshotID = "snapshot_id"
    case tracks, type, uri
  }
}
