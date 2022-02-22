//
//  PlaylistViewController.swift
//  Spotify
//
//  Created by Aybars Acar on 9/2/2022.
//

import UIKit

class PlaylistViewController: UIViewController {
  
  private let playlist: Playlist
  
  public var isOwner = false
  
  private let collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ -> NSCollectionLayoutSection? in
      // Item - represents one of our cells
      let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
      
      // add some padding
      item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 2, bottom: 1, trailing: 2)
      
      // Vertical group inside a horizontal group
      let verticalGroup = NSCollectionLayoutGroup.vertical(
        layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60)),
        subitem: item,
        count: 1
      )
      
      // Section
      let section = NSCollectionLayoutSection(group: verticalGroup)
      
      // add a section header
      section.boundarySupplementaryItems = [
        NSCollectionLayoutBoundarySupplementaryItem(
          layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1)),
          elementKind: UICollectionView.elementKindSectionHeader,
          alignment: .top
        )
      ]
      
      return section
    })
  )
  
  private var viewModels = [RecommendedTrackCellViewModel]()
  private var tracks = [AudioTrack]()
  
  init(playlist: Playlist) {
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
    
    view.addSubview(collectionView)
    
    // register cell and header
    collectionView.register(PlaylistHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier)
    collectionView.register(RecommendedTrackCollectionViewCell.self, forCellWithReuseIdentifier: RecommendedTrackCollectionViewCell.identifier)
    collectionView.backgroundColor = .systemBackground
    collectionView.delegate = self
    collectionView.dataSource = self
    
    APICaller.shared.getPlaylistDetails(for: playlist) { [weak self] result in
      DispatchQueue.main.async {
        switch result {
        case .success(let model):
          self?.tracks = model.tracks.items.compactMap({ $0.track })
          
          self?.viewModels = model.tracks.items.compactMap({ item in
            RecommendedTrackCellViewModel(name: item.track.name, artistName: item.track.artists.first?.name ?? "-", artworkURL: URL(string: item.track.album?.images.first?.url ?? ""))
          })
          
          self?.collectionView.reloadData()
          
        case .failure(let error):
          print(error.localizedDescription)
        }
      }
    }
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShare))
    
    // add long press gesture
    let gesture = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:)))
    collectionView.addGestureRecognizer(gesture)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    collectionView.frame = view.bounds
  }
  
  @objc private func didLongPress(_ gesture: UILongPressGestureRecognizer) {
    
    guard gesture.state == .began else { return }
    
    let touchPoint = gesture.location(in: collectionView)
    
    guard let indexPath = collectionView.indexPathForItem(at: touchPoint) else { return }
    
    let trackToDelete = tracks[indexPath.row]
    
    // show an action sheet
    let actionSheet = UIAlertController(title: "Remove \(trackToDelete.name)", message: "Would you like to remove \(trackToDelete.name) from the playlist", preferredStyle: .actionSheet)
    
    actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    actionSheet.addAction(UIAlertAction(title: "Remove", style: .destructive, handler: { [weak self] _ in
      
      guard let self = self else { return }
      
      APICaller.shared.removeTrackFromPlaylist(trackToDelete, from: self.playlist) { success in
        if success {
          // remove the track from the collection view as well and refresht the collection view
          DispatchQueue.main.async {
            self.tracks.remove(at: indexPath.row)
            self.viewModels.remove(at: indexPath.row)
            self.collectionView.reloadData()
          }
        }
      }
    }))
    
    present(actionSheet, animated: true, completion: nil)
  }
  
  @objc private func didTapShare() {
  
    guard let url = URL(string: playlist.externalUrls["spotify"] ?? "") else {
      return
    }
    
    let vc = UIActivityViewController(activityItems: ["Check out this cool playlist I found!", url], applicationActivities: [])
    
    vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
    present(vc, animated: true)
  }
}


extension PlaylistViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModels.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedTrackCollectionViewCell.identifier, for: indexPath) as? RecommendedTrackCollectionViewCell else {
      return UICollectionViewCell()
    }
    
    cell.configure(with: viewModels[indexPath.row])
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: true)

    // play song
    let index = indexPath.row
    let track = tracks[index]
    
    PlaybackPresenter.shared.startPlayback(from: self, track: track)
  }
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    guard kind == UICollectionView.elementKindSectionHeader else {
      return UICollectionReusableView()
    }
    
    guard let header = collectionView.dequeueReusableSupplementaryView(
      ofKind: kind,
      withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier,
      for: indexPath
    ) as? PlaylistHeaderCollectionReusableView else {
      return UICollectionReusableView()
    }
    
    let headerViewModel = PlaylistHeaderViewModel(
      name: playlist.name,
      ownerName: playlist.owner.displayName,
      description: playlist.itemDescription,
      artworkURL: URL(string: playlist.images.first?.url ?? "")
    )
    
    // configure header
    header.configure(with: headerViewModel)
    
    header.delegate = self
    
    return header
  }
}


extension PlaylistViewController: PlaylistHeaderCollectionReusableViewDelegate {

  func playlistHeaderCollectionReusableViewDidTapPlayAll(_ header: PlaylistHeaderCollectionReusableView) {
    
    PlaybackPresenter.shared.startPlayback(from: self, tracks: tracks)
  }
}
