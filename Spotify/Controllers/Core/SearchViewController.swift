//
//  SearchViewController.swift
//  Spotify
//
//  Created by Aybars Acar on 9/2/2022.
//

import UIKit

class SearchViewController: UIViewController {
  
  let searchController: UISearchController = {

    let vc = UISearchController(searchResultsController: SearchResultsViewController())
    
    vc.searchBar.placeholder = "Songs, Artists, Albums"
    vc.searchBar.searchBarStyle = .minimal
    vc.definesPresentationContext = true
    
    return vc
  }()
  
  private let collectionView: UICollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ -> NSCollectionLayoutSection? in
      let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
      
      item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 7, bottom: 2, trailing: 7)
        
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(150)), subitem: item, count: 2)
      
      group.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
      
      return NSCollectionLayoutSection(group: group)
    })
  )
  
  private var categories: [Category] = []
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .systemBackground
    
    // so we get hold of the text typed in the search bar
    searchController.searchResultsUpdater = self
    
    searchController.searchBar.delegate = self
    
    navigationItem.searchController = searchController
    
    view.addSubview(collectionView)
    collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.backgroundColor = .systemBackground
    collectionView.showsVerticalScrollIndicator = false
    
    APICaller.shared.getCategories { [weak self] result in
      DispatchQueue.main.async {
        switch result {
        case .success(let categories):
          self?.categories = categories
          self?.collectionView.reloadData()
          
        case .failure(let error):
          print(error.localizedDescription)
        }
      }
    }
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    // set the size of the collection view
    collectionView.frame = view.bounds
  }
}


// MARK: - UISearchResultsUpdating
extension SearchViewController: UISearchResultsUpdating, UISearchBarDelegate {
  
  /// called each time the textField inside updates
  func updateSearchResults(for searchController: UISearchController) {
   
  }

  /// called when we click search
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    guard
      let query = searchBar.text,
      !query.trimmingCharacters(in: .whitespaces).isEmpty,
      let resultsController = searchController.searchResultsController as? SearchResultsViewController
    else {
      return
    }
    
    resultsController.delegate = self
    
    APICaller.shared.search(with: query) { result in
      DispatchQueue.main.async {
        
        switch result {
        case .success(let results):
          resultsController.update(with: results)
          
        case .failure(let error):
          print(error.localizedDescription)
        }
      }
    }
  }
}


// MARK: - Collection View Extensions
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return categories.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as? CategoryCollectionViewCell else {
      return UICollectionViewCell()
    }
    
    let category = categories[indexPath.row]
    
    cell.configure(with: CategoryCollectionCellViewModel(title: category.name, artworkURL: URL(string: category.icons?.first?.url ?? "")))
    
    return cell
  }
  
  /// navigate to the CategoryView
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
   
    // unhiglight
    collectionView.deselectItem(at: indexPath, animated: true)
    
    let category = categories[indexPath.row]
    
    // create the page
    let vc = CategoryViewController(category: category)
    vc.navigationItem.largeTitleDisplayMode = .never
    
    // navigate
    navigationController?.pushViewController(vc, animated: true)
  }
}


extension SearchViewController: SearchResultsViewControllerDelegate {
  
  /// handle navigation
  func didTapResult(_ result: SearchResult) {
    
    switch result {
      
    case .artist(model: let model):
      break
      
    case .album(model: let model):
      let vc = AlbumViewController(album: model)
      navigationController?.pushViewController(vc, animated: true)
      vc.navigationItem.largeTitleDisplayMode = .never
      
    case .track(model: let model):
      break
      
    case .playlist(model: let model):
      let vc = PlaylistViewController(playlist: model)
      navigationController?.pushViewController(vc, animated: true)
      vc.navigationItem.largeTitleDisplayMode = .never
    }
  }
}
