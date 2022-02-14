//
//  SearchResult.swift
//  Spotify
//
//  Created by Aybars Acar on 13/2/2022.
//

import Foundation

/// to aggregate our search results into one object
enum SearchResult {
  case artist(model: Artist)
  case album(model: Album)
  case track(model: AudioTrack)
  case playlist(model: Playlist)
}
