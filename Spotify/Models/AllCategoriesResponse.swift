//
//  AllCategoriesResponse.swift
//  Spotify
//
//  Created by Aybars Acar on 13/2/2022.
//

import Foundation

struct AllCategoriesResponse: Codable {
  let categories: Categories
}

struct Categories: Codable {
  let href: String
  let items: [Category]
  let limit: Int
  let next: String?
  let offset: Int
  let previous: String?
  let total: Int
}


struct Category: Codable {
  let href: String?
  let icons: [APIImage]?
  let id, name: String
}
