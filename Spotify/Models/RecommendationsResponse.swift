//
//  RecommendationsResponse.swift
//  Spotify
//
//  Created by Aybars Acar on 12/2/2022.
//

import Foundation

struct RecommendationsResponse: Codable {
  let tracks: [AudioTrack]
  let seeds: [Seed]
}

// MARK: - Seed
struct Seed: Codable {
  let initialPoolSize, afterFilteringSize, afterRelinkingSize: Int
  let id, type: String
  let href: String?
}

