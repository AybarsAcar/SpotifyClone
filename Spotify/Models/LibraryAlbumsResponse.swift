//
//  LibraryAlbumsResponse.swift
//  Spotify
//
//  Created by Aybars Acar on 22/2/2022.
//

import Foundation


struct LibraryAlbumsResponse: Codable {
  let href: String
  let items: [SavedAlbum]
}

struct SavedAlbum: Codable {
  let addedAt: String
  let album: Album
  
  enum CodingKeys: String, CodingKey {
    case album
    case addedAt = "added_at"
  }
}
