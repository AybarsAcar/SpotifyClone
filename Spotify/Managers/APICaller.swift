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
  
  
  func getFeaturedReleases(completion: @escaping (Result<FeaturedPlayListsResponse, Error>) -> Void) {
    
    createRequest(with: URL(string: "\(Constants.baseAPIURL)/browse/featured-playlists?limit=50"), type: .GET) { request in
      let task = URLSession.shared.dataTask(with: request) { data, _, error in
        guard let data = data, error == nil else {
          completion(.failure(APIError.failedToGetData))
          return
        }
        
        do {
          let result = try JSONDecoder().decode(FeaturedPlayListsResponse.self, from: data)
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
    case GET, POST
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
          print(result)
          
        } catch {
          print(error)
          completion(.failure(error))
        }
      }
      
      task.resume()
    }
  }
  
  // MARK: - Playlists
  
  public func getPlaylistDetails(for playlist: PlayList, completion: @escaping (Result<PlaylistDetailsResponse, Error>) -> Void) {
    
    createRequest(with: URL(string: "\(Constants.baseAPIURL)/playlists/\(playlist.id)"), type: .GET) { request in
      let task = URLSession.shared.dataTask(with: request) { data, _, error in
        guard let data = data, error == nil else {
          completion(.failure(APIError.failedToGetData))
          return
        }
        
        do {
          let result = try JSONDecoder().decode(PlaylistDetailsResponse.self, from: data)
          completion(.success(result))
          print(result)
//          print(String(data: data, encoding: .ascii)!)
          
        } catch {
          print(error)
          completion(.failure(error))
        }
      }
      
      task.resume()
    }
  }
}
