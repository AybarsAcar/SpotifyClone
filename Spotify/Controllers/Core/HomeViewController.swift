//
//  HomeViewController.swift
//  Spotify
//
//  Created by Aybars Acar on 9/2/2022.
//

import UIKit

enum BrowseSectionType {
  case newReleases(viewModels: [NewReleasesCellViewModel])
  case featuredPlaylists(viewModels: [NewReleasesCellViewModel])
  case recommendedTracks(viewModels: [NewReleasesCellViewModel])
}

class HomeViewController: UIViewController {
  
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
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    collectionView.frame = view.bounds
  }
  
  private func configureCollectionView() {
    view.addSubview(collectionView)
    collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    collectionView.register(NewReleaseCollectionViewCell.self, forCellWithReuseIdentifier: NewReleaseCollectionViewCell.identifier)
    collectionView.register(FeaturedPlaylistCollectionViewCell.self, forCellWithReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier)
    collectionView.register(RecommendedTrackCollectionViewCell.self, forCellWithReuseIdentifier: RecommendedTrackCollectionViewCell.identifier)

    collectionView.dataSource = self
    collectionView.delegate = self
    
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
    var featuredPlaylist: FeaturedPlayListsResponse?
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
  
  private func configureModels(newAlbums: [Album], playlists: [PlayList], tracks: [AudioTrack]) {
    
    sections.append(.newReleases(viewModels: newAlbums.compactMap({ album in
      return NewReleasesCellViewModel(
        name: album.name,
        artworkURL: URL(string: album.images.first?.url ?? ""),
        numberOfTracks: album.totalTracks,
        artistName: album.artists.first?.name ?? "-"
      )
    })))
    sections.append(.featuredPlaylists(viewModels: []))
    sections.append(.recommendedTracks(viewModels: []))
    
    // when teh modelsa re updated make sure to reload the collection
    collectionView.reloadData()
  }
  
  @objc func didTapSettings() {
    let vc = SettingsViewController()
    vc.title = "Settings"
    vc.navigationItem.largeTitleDisplayMode = .never
    
    navigationController?.pushViewController(vc, animated: true)
  }
  
}


extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  
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
      cell.backgroundColor = .blue
      return cell
      
    case .recommendedTracks(viewModels: let viewModels):
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedTrackCollectionViewCell.identifier, for: indexPath) as? RecommendedTrackCollectionViewCell else {
        return UICollectionViewCell()
      }
      cell.backgroundColor = .orange
      return cell
    }
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return sections.count
  }
  
  private static func createSectionLayout(section: Int) -> NSCollectionLayoutSection {
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
      
      return section
    }
  }
}
