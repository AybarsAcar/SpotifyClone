//
//  LibraryPlaylistsResponse.swift
//  Spotify
//
//  Created by Aybars Acar on 19/2/2022.
//

import Foundation

struct LibraryPlaylistsResponse: Codable {
  let href: String
  let items: [Playlist]
}
