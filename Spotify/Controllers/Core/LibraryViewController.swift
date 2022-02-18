//
//  LibraryViewController.swift
//  Spotify
//
//  Created by Aybars Acar on 9/2/2022.
//

import UIKit

class LibraryViewController: UIViewController {
  
  // assing child view controllers
  private let playlistVC = LibraryPlaylistViewController()
  private let albumsVC = LibraryAlbumsViewController()
  
  private let scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.isPagingEnabled = true
    scrollView.showsHorizontalScrollIndicator = false
    return scrollView
  }()
  
  private let toggleView = LibraryToggleView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .systemBackground
    
    // assign scrollview
    scrollView.delegate = self
    
    // toggle view
    toggleView.delegate = self
    
    // add subviews
    view.addSubview(scrollView)
    view.addSubview(toggleView)
    
    // so we can swipe left and right to change content
    scrollView.contentSize = CGSize(width: view.width * 2, height: scrollView.height)
    
    addChildren()
    updateBarButtons()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    scrollView.frame = CGRect(x: 0, y: view.safeAreaInsets.top + 55, width: view.width, height: view.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom - 55)
    
    toggleView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: 200, height: 55)
  }
  
  private func updateBarButtons() {
    if toggleView.state == .playlist {
      navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
    }
    
    if toggleView.state == .album {
      navigationItem.rightBarButtonItem = nil
    }
  }
  
  /// add children components
  private func addChildren() {
    
    // add playlist
    addChild(playlistVC)
    scrollView.addSubview(playlistVC.view)
    playlistVC.view.frame = CGRect(x: 0, y: 0, width: scrollView.width, height: scrollView.height)
    
    // let the child know that they are a child now
    playlistVC.didMove(toParent: self)
    
    // add albums
    addChild(albumsVC)
    scrollView.addSubview(albumsVC.view)
    albumsVC.view.frame = CGRect(x: view.width, y: 0, width: scrollView.width, height: scrollView.height)
    
    // let the child know that they are a child now
    albumsVC.didMove(toParent: self)
  }

  @objc func didTapAdd() {
    playlistVC.showCreatePlaylistAlert()
  }
}


/// Scroll View Configuration
extension LibraryViewController: UIScrollViewDelegate {
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    // if the offset is 100 off the edge scroll to albums
    if scrollView.contentOffset.x >= (view.width - 100) {
      toggleView.update(for: .album)
      updateBarButtons()
    }
    else {
      toggleView.update(for: .playlist)
      updateBarButtons()
    }
  }
}


/// Toggle View COnfiguration
extension LibraryViewController: LibraryToggleViewDelegate {
  
  func libraryToggleViewDidTapPlaylists(_ toggleView: LibraryToggleView) {
    scrollView.setContentOffset(.zero, animated: true)
    updateBarButtons()
  }
  
  func libraryToggleViewDidTapAlbums(_ toggleView: LibraryToggleView) {
    scrollView.setContentOffset(CGPoint(x: view.width, y: 0), animated: true)
    updateBarButtons()
  }
  
}
