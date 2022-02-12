//
//  SettingsModels.swift
//  Spotify
//
//  Created by Aybars Acar on 12/2/2022.
//

import Foundation

struct Section {
  let title: String
  let options: [Option]
}

struct Option {
  let title: String
  let handler: () -> Void
}
