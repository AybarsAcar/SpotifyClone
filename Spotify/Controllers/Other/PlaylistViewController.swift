//
//  PlaylistViewController.swift
//  Spotify
//
//  Created by Aybars Acar on 9/2/2022.
//

import UIKit

class PlaylistViewController: UIViewController {
  
  private let playlist: PlayList
  
  init(playlist: PlayList) {
    self.playlist = playlist
    super.init(nibName: nil, bundle: nil) // because no .xib file
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = playlist.name
    view.backgroundColor = .systemBackground
    
    APICaller.shared.getPlaylistDetails(for: playlist) { result in
      switch result {
        
      case .success(let model):
        break
      case .failure(let error):
        break
      }
    }
  }
}
