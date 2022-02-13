//
//  CategoryViewController.swift
//  Spotify
//
//  Created by Aybars Acar on 13/2/2022.
//

import UIKit

class CategoryViewController: UIViewController {
  
  let category: Category
  
  private var playlists: [PlayList] = []
  
  private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ -> NSCollectionLayoutSection? in
    let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
    
    item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
    
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(260)), subitem: item, count: 2)
    
    group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
    
    return NSCollectionLayoutSection(group: group)
  }))
  
  // MARK: - Init
  
  init(category: Category) {
    self.category = category
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = category.name
    
    // add collection view
    view.addSubview(collectionView)
    view.backgroundColor = .systemBackground
    collectionView.backgroundColor = .systemBackground
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.register(FeaturedPlaylistCollectionViewCell.self, forCellWithReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier)
    
    APICaller.shared.getCategoryPlaylists(category: category) { [weak self] result in
      DispatchQueue.main.async {
        
        switch result {
        case .success(let playlists):
          self?.playlists = playlists
          self?.collectionView.reloadData()
          
        case .failure(let error):
          print(error.localizedDescription)
        }
      }
    }
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    collectionView.frame = view.bounds
  }
  
}


// MARK: - UICollectionView
extension CategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return playlists.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier, for: indexPath) as? FeaturedPlaylistCollectionViewCell else {
      return UICollectionViewCell()
    }
    
    let playlist = playlists[indexPath.row]
    
    cell.configure(with: FeaturedPlaylistCellViewModel(name: playlist.name, artworkURL: URL(string: playlist.images.first?.url ?? ""), creatorName: playlist.owner.displayName))
    
    return cell
  }
  
  /// navigates to the playlist view
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: true)
    
    // create a playlist view
    let vc = PlaylistViewController(playlist: playlists[indexPath.row])
    vc.navigationItem.largeTitleDisplayMode = .never
    
    // navigate to it
    navigationController?.pushViewController(vc, animated: true)
  }
}
