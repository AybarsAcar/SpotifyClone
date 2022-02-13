//
//  AlbumViewController.swift
//  Spotify
//
//  Created by Aybars Acar on 12/2/2022.
//

import UIKit

class AlbumViewController: UIViewController {
  
  private let album: Album
  
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
  
  private var viewModels = [AlbumCollectionCellViewModel]()

  
  init(album: Album) {
    self.album = album
    super.init(nibName: nil, bundle: nil) // because no .xib file
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.addSubview(collectionView)
    
    // register cell and header
    collectionView.register(PlaylistHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier)
    collectionView.register(AlbumTrackCollectionViewCell.self, forCellWithReuseIdentifier: AlbumTrackCollectionViewCell.identifier)
    collectionView.backgroundColor = .systemBackground
    collectionView.delegate = self
    collectionView.dataSource = self
    
    title = album.name
    view.backgroundColor = .systemBackground
    
    APICaller.shared.getAlbumDetails(for: album) { [weak self] result in
      DispatchQueue.main.async {
        switch result {
        case .success(let model):
          
          self?.viewModels = model.tracks.items.compactMap({ item in
            AlbumCollectionCellViewModel(name: item.name, artistName: item.artists.first?.name ?? "-")
          })
          
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



extension AlbumViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModels.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumTrackCollectionViewCell.identifier, for: indexPath) as? AlbumTrackCollectionViewCell else {
      return UICollectionViewCell()
    }
    
    cell.configure(with: viewModels[indexPath.row])
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: true)

    // play song
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
      name: album.name,
      ownerName: album.artists.first?.name,
      description: "Release Date: \(String.formattedDate(album.releaseDate))",
      artworkURL: URL(string: album.images.first?.url ?? "")
    )

    // configure header
    header.configure(with: headerViewModel)
    
    header.delegate = self
    
    return header
  }
}


extension AlbumViewController: PlaylistHeaderCollectionReusableViewDelegate {
  func playlistHeaderCollectionReusableViewDidTapPlayAll(_ header: PlaylistHeaderCollectionReusableView) {
    print("PLAYING ALL")
  }
}
