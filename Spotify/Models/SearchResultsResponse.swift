//
//  SearchResultsResponse.swift
//  Spotify
//
//  Created by Aybars Acar on 13/2/2022.
//

import Foundation

/// we need to make the following optional if we decide to remove them from our query
/// then each of the variable of this struct must be optional
struct SearchResultsResponse: Codable {
  let albums: SearchAlbumResponse
  let artists: SearchArtistsResponse
  let tracks: SearchAudioTrackResponse
  let playlists: SearchPlaylistsResponse
}

struct SearchAlbumResponse: Codable {
  let href: String
  let items: [Album]
  let limit: Int
  let next: String?
  let offset: Int
  let previous: String?
  let total: Int
}

struct SearchArtistsResponse: Codable {
  let href: String
  let items: [Artist]
  let limit: Int
  let next: String?
  let offset: Int
  let previous: String?
  let total: Int
}

struct SearchPlaylistsResponse: Codable {
  let href: String
  let items: [Playlist]
  let limit: Int
  let next: String?
  let offset: Int
  let previous: String?
  let total: Int
}

struct SearchAudioTrackResponse: Codable {
  let href: String
  let items: [AudioTrack]
  let limit: Int
  let next: String?
  let offset: Int
  let previous: String?
  let total: Int
}
