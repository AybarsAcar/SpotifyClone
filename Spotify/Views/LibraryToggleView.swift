//
//  LibraryToggleView.swift
//  Spotify
//
//  Created by Aybars Acar on 19/2/2022.
//

import UIKit

protocol LibraryToggleViewDelegate: AnyObject {
  
  func libraryToggleViewDidTapPlaylists(_ toggleView: LibraryToggleView)
  
  func libraryToggleViewDidTapAlbums(_ toggleView: LibraryToggleView)
}

class LibraryToggleView: UIView {
  
  enum SelectionState {
    case playlist, album
  }
  
  var state: SelectionState = .playlist
  
  weak var delegate: LibraryToggleViewDelegate?
  
  private let playlistsButton: UIButton = {
    let button = UIButton()
    button.setTitleColor(.label, for: .normal)
    button.setTitle("Playlists", for: .normal)
    return button
  }()
  
  private let albumsButton: UIButton = {
    let button = UIButton()
    button.setTitleColor(.label, for: .normal)
    button.setTitle("Albums", for: .normal)
    return button
  }()
  
  private let indicatorView: UIView = {
    let view = UIView()
    view.backgroundColor = .label
    view.layer.masksToBounds = true
    view.layer.cornerRadius = 4
    return view
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    // add subviews
    addSubview(playlistsButton)
    addSubview(albumsButton)
    addSubview(indicatorView)
    
    // add targets
    playlistsButton.addTarget(self, action: #selector(didTapPlaylistsButton), for: .touchUpInside)
    albumsButton.addTarget(self, action: #selector(didTapAlbumsButton), for: .touchUpInside)
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    // lay the subviews out
    playlistsButton.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
    albumsButton.frame = CGRect(x: playlistsButton.right, y: 0, width: 100, height: 50)
    
    layoutIndicator()
    
  }
  
  /// to lay out the indicator when scrolling from the parent
  func update(for state: SelectionState) {
    self.state = state
    UIView.animate(withDuration: 0.2) {
      self.layoutIndicator()
    }
  }
  
  /// lays out indicated based on the selection
  private func layoutIndicator() {
    switch state {
    case .playlist:
      indicatorView.frame = CGRect(x: 0, y: playlistsButton.bottom, width: 100, height: 3)
    case .album:
      indicatorView.frame = CGRect(x: 100, y: playlistsButton.bottom, width: 100, height: 3)
    }
  }
  
  // MARK: - Button Actions
  
  @objc private func didTapPlaylistsButton() {
    state = .playlist
    
    // to animate the indicator
    UIView.animate(withDuration: 0.2) {
      self.layoutIndicator()
    }
    
    delegate?.libraryToggleViewDidTapPlaylists(self)
  }
  
  @objc private func didTapAlbumsButton() {
    state = .album
    
    // to animate the indicator
    UIView.animate(withDuration: 0.2) {
      self.layoutIndicator()
    }
    
    delegate?.libraryToggleViewDidTapAlbums(self)
  }
}
