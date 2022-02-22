//
//  APICaller.swift
//  Spotify
//
//  Created by Aybars Acar on 9/2/2022.
//

import Foundation

final class APICaller {
  static let shared = APICaller()
  private init() { }
  
  // MARK: - Profile
  
  func getCurrentUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) {
    
    createRequest(with: URL(string: "\(Constants.baseAPIURL)/me"), type: .GET) { baseRequest in
      
      let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
        guard let data = data, error == nil else{
          completion(.failure(APIError.failedToGetData))
          return
        }
        
        do {
          let result = try JSONDecoder().decode(UserProfile.self, from: data)
          completion(.success(result))
        } catch {
          print(error.localizedDescription)
          completion(.failure(error))
        }
      }
      
      task.resume()
    }
  }
  
  // MARK: - Browse
  
  func getNewReleases(completion: @escaping (Result<NewReleasesResponse, Error>) -> Void) {
    
    createRequest(with: URL(string: "\(Constants.baseAPIURL)/browse/new-releases?limit=50"), type: .GET) { request in
      let task = URLSession.shared.dataTask(with: request) { data, _, error in
        guard let data = data, error == nil else {
          completion(.failure(APIError.failedToGetData))
          return
        }
        
        do {
          let result = try JSONDecoder().decode(NewReleasesResponse.self, from: data)
          completion(.success(result))
        } catch {
          print(error.localizedDescription)
          completion(.failure(error))
        }
      }
      
      task.resume()
    }
  }
  
  
  func getFeaturedReleases(completion: @escaping (Result<FeaturedPlaylistsResponse, Error>) -> Void) {
    
    createRequest(with: URL(string: "\(Constants.baseAPIURL)/browse/featured-playlists?limit=50"), type: .GET) { request in
      let task = URLSession.shared.dataTask(with: request) { data, _, error in
        guard let data = data, error == nil else {
          completion(.failure(APIError.failedToGetData))
          return
        }
        
        do {
          let result = try JSONDecoder().decode(FeaturedPlaylistsResponse.self, from: data)
          completion(.success(result))
        } catch {
          print(error.localizedDescription)
          completion(.failure(error))
        }
      }
      
      task.resume()
    }
  }
  
  func getRecommendations(genres: Set<String>,completion: @escaping (Result<RecommendationsResponse, Error>) -> Void) {
    
    let seeds: String = genres.joined(separator: ",")
    
    createRequest(with: URL(string: "\(Constants.baseAPIURL)/recommendations?seed_genres=\(seeds)"), type: .GET) { request in
      let task = URLSession.shared.dataTask(with: request) { data, _, error in
        guard let data = data, error == nil else {
          completion(.failure(APIError.failedToGetData))
          return
        }
        
        do {
          let result = try JSONDecoder().decode(RecommendationsResponse.self, from: data)
          completion(.success(result))
        } catch {
          print(error.localizedDescription)
          completion(.failure(error))
        }
      }
      
      task.resume()
    }
  }
  
  func getRecommendedGenres(completion: @escaping (Result<RecommendedGenresResponse, Error>) -> Void) {
    
    createRequest(with: URL(string: "\(Constants.baseAPIURL)/recommendations/available-genre-seeds"), type: .GET) { request in
      let task = URLSession.shared.dataTask(with: request) { data, _, error in
        guard let data = data, error == nil else {
          completion(.failure(APIError.failedToGetData))
          return
        }
        
        do {
          let result = try JSONDecoder().decode(RecommendedGenresResponse.self, from: data)
          completion(.success(result))
        } catch {
          print(error.localizedDescription)
          completion(.failure(error))
        }
      }
      
      task.resume()
    }
  }
}


extension APICaller {
  
  struct Constants {
    static let baseAPIURL = "https://api.spotify.com/v1"
  }
  
  enum APIError: Error {
    case failedToGetData
  }
  
  // MARK: - Private
  
  enum HTTPMethod: String {
    case GET, POST, DELETE, PUT
  }
  
  private func createRequest(with url: URL?, type: HTTPMethod ,completion: @escaping (URLRequest) -> Void) {
    
    AuthManager.shared.withValidToken { token in
      guard let url = url else { return }
      
      var request = URLRequest(url: url)
      request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
      request.httpMethod = type.rawValue
      request.timeoutInterval = 30
      
      completion(request)
    }
  }
  
  // MARK: - Albums
  
  public func getAlbumDetails(for album: Album, completion: @escaping (Result<AlbumDetailsResponse, Error>) -> Void) {
    
    createRequest(with: URL(string: "\(Constants.baseAPIURL)/albums/\(album.id)"), type: .GET) { request in
      let task = URLSession.shared.dataTask(with: request) { data, _, error in
        guard let data = data, error == nil else {
          completion(.failure(APIError.failedToGetData))
          return
        }
        
        do {
          let result = try JSONDecoder().decode(AlbumDetailsResponse.self, from: data)
          completion(.success(result))
          
        } catch {
          print(error)
          completion(.failure(error))
        }
      }
      
      task.resume()
    }
  }
  
  func getCurrentUserAlbums(completion: @escaping (Result<[Album], Error>) -> Void) {
    createRequest(with: URL(string: "\(Constants.baseAPIURL)/me/albums"), type: .GET) { request in
      
      let task = URLSession.shared.dataTask(with: request) { data, _, error in
        guard let data = data, error == nil else {
          completion(.failure(APIError.failedToGetData))
          return
        }

        do {
          let result = try JSONDecoder().decode(LibraryAlbumsResponse.self, from: data)
          completion(.success(result.items.compactMap({ $0.album })))
          
        } catch {
          print(error)
          completion(.failure(error))
        }
      }
      
      task.resume()
    }
  }
  
  func saveAlbum(_ album: Album, completion: @escaping (Bool) -> Void) {
    createRequest(with: URL(string: "\(Constants.baseAPIURL)/me/albums?ids=\(album.id)"), type: .PUT) { baseRequest in
      var request = baseRequest
      
      request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      
      let task = URLSession.shared.dataTask(with: request) { _, response, error in
        guard error == nil else {
          completion(false)
          return
        }
        
        if let response = response as? HTTPURLResponse, response.statusCode >= 200, response.statusCode < 300 {
          completion(true)
        } else {
          completion(false)
        }
      }
      
      task.resume()
    }
  }
  
  // MARK: - Playlists
  
  public func getPlaylistDetails(for playlist: Playlist, completion: @escaping (Result<PlaylistDetailsResponse, Error>) -> Void) {
    
    createRequest(with: URL(string: "\(Constants.baseAPIURL)/playlists/\(playlist.id)"), type: .GET) { request in
      let task = URLSession.shared.dataTask(with: request) { data, _, error in
        guard let data = data, error == nil else {
          completion(.failure(APIError.failedToGetData))
          return
        }
        
        do {
          let result = try JSONDecoder().decode(PlaylistDetailsResponse.self, from: data)
          completion(.success(result))
 
        } catch {
          print(error)
          completion(.failure(error))
        }
      }
      
      task.resume()
    }
  }
  
  func getCurrentUserPlaylists(completion: @escaping (Result<[Playlist], Error>) -> Void) {
    createRequest(with: URL(string: "\(Constants.baseAPIURL)/me/playlists"), type: .GET) { request in
      
      let task = URLSession.shared.dataTask(with: request) { data, _, error in
        guard let data = data, error == nil else {
          completion(.failure(APIError.failedToGetData))
          return
        }

        do {
          let result = try JSONDecoder().decode(LibraryPlaylistsResponse.self, from: data)
          completion(.success(result.items))
          
        } catch {
          print(error)
          completion(.failure(error))
        }
      }
      
      task.resume()
    }
  }

  /// TODO: Improvemnets -> cache the user id to avoid extra request
  func createPlaylist(with name: String, completion: @escaping (Bool) -> Void) {
    // "/users/{user_id}/playlists"
    getCurrentUserProfile { [weak self] result in
      switch result {
      case .success(let profile):
        let urlString = "\(Constants.baseAPIURL)/users/\(profile.id)/playlists"
        
        self?.createRequest(with: URL(string: urlString), type: .POST) { baseRequest in
          
          var request = baseRequest
          let postValues = ["name": name]
          
          request.httpBody = try? JSONSerialization.data(withJSONObject: postValues, options: .fragmentsAllowed)
          
          let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
              completion(false)
              return
            }
            
            do {
              let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
              
              if let response = result as? [String: Any],
                 response["id"] as? String != nil {
                
                completion(true)
                return
              }

              completion(false)
              
            } catch {
              print(error)
              completion(false)
            }
          }
          
          task.resume()
        }
        
      case .failure(let error):
        print(error)
        completion(false)
      }
    }
  }
  
  func addTrackToPlaylist(_ track: AudioTrack, to playlist: Playlist, completion: @escaping (Bool) -> Void) {
    createRequest(with: URL(string: "\(Constants.baseAPIURL)/playlists/\(playlist.id)/tracks"), type: .POST) { baseRequest in
      var request = baseRequest
      
      let json = [
        "uris": ["spotify:track:\(track.id)"]
      ]
      
      request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
      request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      
      let task = URLSession.shared.dataTask(with: request) { data, _, error in
        guard let data = data, error == nil else {
          completion(false)
          return
        }

        do {
          let result = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                    
          if let response = result as? [String: Any], response["snapshot_id"] as? String != nil {
            completion(true)
          } else {
            completion(false)
          }
        } catch {
          completion(false)
        }
      }
      
      task.resume()
    }
  }
  
  func removeTrackFromPlaylist(_ track: AudioTrack, from playlist: Playlist, completion: @escaping (Bool) -> Void) {
    createRequest(with: URL(string: "\(Constants.baseAPIURL)/playlists/\(playlist.id)/tracks"), type: .DELETE) { baseRequest in
      var request = baseRequest
      
      let json: [String: Any] = [
        "tracks": [
          [
            "uri": "spotify:track:\(track.id)"
          ]
        ]
      ]
      
      request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
      request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      
      let task = URLSession.shared.dataTask(with: request) { data, _, error in
        guard let data = data, error == nil else {
          completion(false)
          return
        }

        do {
          let result = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                    
          if let response = result as? [String: Any], response["snapshot_id"] as? String != nil {
            completion(true)
          } else {
            completion(false)
          }
        } catch {
          completion(false)
        }
      }
      
      task.resume()
    }
  }
  
  // MARK: - Category
  
  public func getCategories(completion: @escaping (Result<[Category], Error>) -> Void) {
    
    createRequest(with: URL(string: "\(Constants.baseAPIURL)/browse/categories?limit=50"), type: .GET) { request in
      let task = URLSession.shared.dataTask(with: request) { data, _, error in
        guard let data = data, error == nil else {
          completion(.failure(APIError.failedToGetData))
          return
        }

        do {
          let result = try JSONDecoder().decode(AllCategoriesResponse.self, from: data)
          completion(.success(result.categories.items))
        } catch {
          print(error)
          completion(.failure(error))
        }
      }
      
      task.resume()
    }
  }
  
  public func getCategoryPlaylists(category: Category, completion: @escaping (Result<[Playlist], Error>) -> Void) {
    
    createRequest(with: URL(string: "\(Constants.baseAPIURL)/browse/categories/\(category.id)/playlists"), type: .GET) { request in
      let task = URLSession.shared.dataTask(with: request) { data, _, error in
        guard let data = data, error == nil else {
          completion(.failure(APIError.failedToGetData))
          return
        }

        do {
          let result = try JSONDecoder().decode(CategoryPlaylistsResponse.self, from: data)
          completion(.success(result.playlists.items))
        } catch {
          print(error)
          completion(.failure(error))
        }
      }
      
      task.resume()
    }
  }
  
  
  // MARK: - Search
  
  func search(with query: String, completion: @escaping (Result<[SearchResult], Error>) -> Void) {
    
    let urlString = "\(Constants.baseAPIURL)/search?limit=10&type=album,artist,playlist,track&q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
    
    createRequest(with: URL(string: urlString), type: .GET) { request in
      let task = URLSession.shared.dataTask(with: request) { data, _, error in
        guard let data = data, error == nil else {
          completion(.failure(APIError.failedToGetData))
          return
        }

        do {
          let result = try JSONDecoder().decode(SearchResultsResponse.self, from: data)

          var searchResults: [SearchResult] = []
          
          searchResults.append(contentsOf: result.tracks.items.compactMap({ .track(model: $0) }))
          searchResults.append(contentsOf: result.albums.items.compactMap({ .album(model: $0) }))
          searchResults.append(contentsOf: result.artists.items.compactMap({ .artist(model: $0) }))
          searchResults.append(contentsOf: result.playlists.items.compactMap({ .playlist(model: $0) }))

          completion(.success(searchResults))
          
        } catch {
          print(error)
          completion(.failure(error))
        }
      }
      
      task.resume()
    }
  }
}
