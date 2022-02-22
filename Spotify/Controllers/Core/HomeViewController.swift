//
//  HomeViewController.swift
//  Spotify
//
//  Created by Aybars Acar on 9/2/2022.
//

import UIKit

enum BrowseSectionType {
  case newReleases(viewModels: [NewReleasesCellViewModel])
  case featuredPlaylists(viewModels: [FeaturedPlaylistCellViewModel])
  case recommendedTracks(viewModels: [RecommendedTrackCellViewModel])
  
  var title: String {
    switch self {
    case .newReleases:
      return "New Released Albums"
    case .featuredPlaylists:
      return "Featured Playlists"
    case .recommendedTracks:
      return "Recommended"
    }
  }
}

class HomeViewController: UIViewController {
  
  private var newAlbums: [Album] = []
  private var playlists: [Playlist] = []
  private var tracks: [AudioTrack] = []
  
  private var collectionView: UICollectionView = {
    let layout = UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
      return HomeViewController.createSectionLayout(section: sectionIndex)
    }
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.showsVerticalScrollIndicator = false
    
    return collectionView
  }()
  
  private let spinner: UIActivityIndicatorView = {
    let spinner = UIActivityIndicatorView()
    spinner.tintColor = .label
    spinner.hidesWhenStopped = true
    return spinner
  }()
  
  private var sections: [BrowseSectionType] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    
    title = "Browse"
    view.backgroundColor = .systemBackground
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(didTapSettings))
    
    configureCollectionView()
    
    view.addSubview(spinner)
    
    fetchData()
    
    addLongTapGesture()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    collectionView.frame = view.bounds
  }
  
  private func addLongTapGesture() {
    let gesture = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:)))
    collectionView.isUserInteractionEnabled = true
    collectionView.addGestureRecognizer(gesture)
  }
  
  private func configureCollectionView() {
    
    // add the collection view
    view.addSubview(collectionView)
    
    // register the cells
    collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    collectionView.register(NewReleaseCollectionViewCell.self, forCellWithReuseIdentifier: NewReleaseCollectionViewCell.identifier)
    collectionView.register(FeaturedPlaylistCollectionViewCell.self, forCellWithReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier)
    collectionView.register(RecommendedTrackCollectionViewCell.self, forCellWithReuseIdentifier: RecommendedTrackCollectionViewCell.identifier)
    
    // register the header
    collectionView.register(TitleHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleHeaderCollectionReusableView.identifier)

    // bind the datasource and delegate
    collectionView.dataSource = self
    collectionView.delegate = self
    
    // set background color
    collectionView.backgroundColor = .systemBackground
  }
  
  /// fetches the data as an aggregate
  private func fetchData() {
    
    // to await for multiple api calls
    let group = DispatchGroup()
    group.enter()
    group.enter()
    group.enter()
    
    var newReleases: NewReleasesResponse?
    var featuredPlaylist: FeaturedPlaylistsResponse?
    var recommendations: RecommendationsResponse?
    
    // New Releases
    APICaller.shared.getNewReleases { result in
      defer {
        group.leave()
      }
      
      switch result {
      case .success(let model):
        newReleases = model
        
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
    
    // Featured Playlists
    APICaller.shared.getFeaturedReleases { result in
      defer {
        group.leave()
      }
      
      switch result {
      case .success(let model):
        featuredPlaylist = model
        
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
    
    // Recommended Tracks
    APICaller.shared.getRecommendedGenres { result in
      
      switch result {
      case .success(let model):
        let genres = model.genres
        var seeds = Set<String>()
        
        while seeds.count < 5 {
          if let random = genres.randomElement() {
            seeds.insert(random)
          }
        }
        
        APICaller.shared.getRecommendations(genres: seeds) { recommendedResult in
          defer {
            group.leave()
          }
          
          switch recommendedResult {
          case .success(let model):
            recommendations = model
            
          case .failure(let error):
            print(error.localizedDescription)
          }
        }
        
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
    
    // notify and execute when all the api calls return
    // called when the group hits 0
    group.notify(queue: .main) {
      guard let newAlbums = newReleases?.albums.items,
            let playlists = featuredPlaylist?.playlists.items,
            let tracks = recommendations?.tracks
      else {
        fatalError("Models are nil")
      }
      
      self.configureModels(newAlbums: newAlbums, playlists: playlists, tracks: tracks)
    }
  }
 
  
  private func configureModels(newAlbums: [Album], playlists: [Playlist], tracks: [AudioTrack]) {
    // cache them so we can refer to it when the user taps on it as we are navigating
    self.newAlbums = newAlbums
    self.playlists = playlists
    self.tracks = tracks
    
    sections.append(.newReleases(viewModels: newAlbums.compactMap({ album in
      return NewReleasesCellViewModel(
        name: album.name,
        artworkURL: URL(string: album.images.first?.url ?? ""),
        numberOfTracks: album.totalTracks,
        artistName: album.artists.first?.name ?? "-"
      )
    })))
    
    sections.append(.featuredPlaylists(viewModels: playlists.compactMap({ item in
      return FeaturedPlaylistCellViewModel(name: item.name, artworkURL: URL(string: item.images.first?.url ?? ""), creatorName: item.owner.displayName)
    })))
    
    sections.append(.recommendedTracks(viewModels: tracks.compactMap({ item in
      return RecommendedTrackCellViewModel(name: item.name, artistName: item.artists.first?.name ?? "-", artworkURL: URL(string: item.album?.images.first?.url ?? ""))
    })))
    
    // when teh modelsa re updated make sure to reload the collection
    collectionView.reloadData()
  }
  
  @objc func didTapSettings() {
    let vc = SettingsViewController()
    vc.title = "Settings"
    vc.navigationItem.largeTitleDisplayMode = .never
    
    navigationController?.pushViewController(vc, animated: true)
  }
  
  @objc func didLongPress(_ gesture: UILongPressGestureRecognizer) {
    
    guard gesture.state == .began else { return }
    
    let touchPoint = gesture.location(in: collectionView)
    
    guard let indexPath = collectionView.indexPathForItem(at: touchPoint), indexPath.section == 2 else {
      return
    }
    
    // ge the track
    let model = tracks[indexPath.row]
    
    // create an action sheet
    let actionSheet = UIAlertController(title: model.name, message: "Would you like to add this to a playlist?", preferredStyle: .actionSheet)
    
    actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    actionSheet.addAction(UIAlertAction(title: "Add to Playlist", style: .default, handler: { [weak self] _ in
      DispatchQueue.main.async {
        let vc = LibraryPlaylistViewController()
        
        vc.selectionHandler = { playlist in
          APICaller.shared.addTrackToPlaylist(model, to: playlist) { success in
            print("Added to playlist success: \(success)")
          }
        }
        
        vc.title = "Select Playlist"
        self?.present(UINavigationController(rootViewController: vc), animated: true)
      }
    }))
    
    present(actionSheet, animated: true)
  }
}


extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: true)
    
    HapticsManager.shared.vibrateForSelection()
    
    let section = sections[indexPath.section]
    
    switch section {
    case .newReleases(viewModels: let viewModels):
      let album = newAlbums[indexPath.row] // get the album clicked
      
      let vc = AlbumViewController(album: album)
      vc.title = album.name
      vc.navigationItem.largeTitleDisplayMode = .never
      
      // navigate to it - push it onto the navigation stack
      navigationController?.pushViewController(vc, animated: true)

    case .featuredPlaylists(viewModels: let viewModels):
      let playlist = playlists[indexPath.row] // get the album clicked
      
      let vc = PlaylistViewController(playlist: playlist)
      vc.title = playlist.name
      vc.navigationItem.largeTitleDisplayMode = .never
      
      // navigate to it - push it onto the navigation stack
      navigationController?.pushViewController(vc, animated: true)
      break

    case .recommendedTracks(viewModels: let viewModels):
      let track = tracks[indexPath.row]
      PlaybackPresenter.shared.startPlayback(from: self, track: track)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    let type = sections[section]
    
    switch type {
    case .newReleases(viewModels: let viewModels):
      return viewModels.count
    case .featuredPlaylists(viewModels: let viewModels):
      return viewModels.count
    case .recommendedTracks(viewModels: let viewModels):
      return viewModels.count
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let type = sections[indexPath.section]

    switch type {
    case .newReleases(viewModels: let viewModels):
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewReleaseCollectionViewCell.identifier, for: indexPath) as? NewReleaseCollectionViewCell else {
        return UICollectionViewCell()
      }
      
      let viewModel = viewModels[indexPath.row]
      
      cell.configure(with: viewModel)
      return cell

    case .featuredPlaylists(viewModels: let viewModels):
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier, for: indexPath) as? FeaturedPlaylistCollectionViewCell else {
        return UICollectionViewCell()
      }
      let viewModel = viewModels[indexPath.row]

      cell.configure(with: viewModel)
      return cell
      
    case .recommendedTracks(viewModels: let viewModels):
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedTrackCollectionViewCell.identifier, for: indexPath) as? RecommendedTrackCollectionViewCell else {
        return UICollectionViewCell()
      }
      
      let viewModel = viewModels[indexPath.row]

      cell.configure(with: viewModel)
      return cell
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    guard
      let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TitleHeaderCollectionReusableView.identifier, for: indexPath) as? TitleHeaderCollectionReusableView,
      kind == UICollectionView.elementKindSectionHeader
    else {
      return UICollectionReusableView()
    }
    
    let section = indexPath.section
    let sectionType = sections[section]
    
    header.configure(with: sectionType.title)
    
    return header
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return sections.count
  }
  
  private static func createSectionLayout(section: Int) -> NSCollectionLayoutSection {
    
    // add a section header
    let supplementaryViews = [
      NSCollectionLayoutBoundarySupplementaryItem(
        layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)),
        elementKind: UICollectionView.elementKindSectionHeader,
        alignment: .top
      )
    ]
    
    switch section {
    case 0:
      // Item - represents one of our cells
      let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
      
      // add some padding
      item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
      
      // Vertical group inside a horizontal group
      let verticalGroup = NSCollectionLayoutGroup.vertical(
        layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(390)),
        subitem: item,
        count: 3
      )
      
      let horizontalGroup = NSCollectionLayoutGroup.horizontal(
        layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.90), heightDimension: .absolute(390)),
        subitem: verticalGroup,
        count: 1
      )
      
      // Section
      let section = NSCollectionLayoutSection(group: horizontalGroup)
      section.orthogonalScrollingBehavior = .groupPaging
      
      section.boundarySupplementaryItems = supplementaryViews
      
      return section
      
    case 1:
      // Item - represents one of our cells
      let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(200), heightDimension: .absolute(200)))
      
      // add some padding
      item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
      
      let verticalGroup = NSCollectionLayoutGroup.vertical(
        layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(200), heightDimension: .absolute(400)),
        subitem: item,
        count: 2
      )
      
      let horizontalGroup = NSCollectionLayoutGroup.horizontal(
        layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(200), heightDimension: .absolute(400)),
        subitem: verticalGroup,
        count: 1
      )
      
      // Section
      let section = NSCollectionLayoutSection(group: horizontalGroup)
      section.orthogonalScrollingBehavior = .continuous
      
      section.boundarySupplementaryItems = supplementaryViews
      
      return section
      
    case 2:
      // Item - represents one of our cells
      let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
      
      // add some padding
      item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
      
      // Vertical group inside a horizontal group
      let verticalGroup = NSCollectionLayoutGroup.vertical(
        layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(80)),
        subitem: item,
        count: 1
      )
      
      // Section
      let section = NSCollectionLayoutSection(group: verticalGroup)
      
      section.boundarySupplementaryItems = supplementaryViews
      
      return section
      
    default:
      // Item - represents one of our cells
      let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
      
      // add some padding
      item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
      
      let verticalGroup = NSCollectionLayoutGroup.vertical(
        layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(390)),
        subitem: item,
        count: 1
      )
      
      // Section
      let section = NSCollectionLayoutSection(group: verticalGroup)
      
      section.boundarySupplementaryItems = supplementaryViews
      
      return section
    }
  }
}
