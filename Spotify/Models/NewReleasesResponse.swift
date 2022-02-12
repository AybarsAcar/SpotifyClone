//
//  NewReleasesResponse.swift
//  Spotify
//
//  Created by Aybars Acar on 12/2/2022.
//

import Foundation

struct NewReleasesResponse: Codable {
  let albums: AlbumsResponse
}

struct AlbumsResponse: Codable {
  let items: [Album]
}

struct Album: Codable {
  let albumType: String
  let artists: [Artist]
  let availableMarkets: [String]
  let href: String
  let id: String
  let images: [APIImage]
  let name, releaseDate, releaseDatePrecision: String
  let totalTracks: Int
  let type, uri: String
  
  enum CodingKeys: String, CodingKey {
    case albumType = "album_type"
    case artists
    case availableMarkets = "available_markets"
    case href, id, name, images
    case releaseDate = "release_date"
    case releaseDatePrecision = "release_date_precision"
    case totalTracks = "total_tracks"
    case type, uri
  }
}

/*
 {
   "albums" : {
     "href" : "https://api.spotify.com/v1/browse/new-releases?locale=en-US%2Cen%3Bq%3D0.9&offset=0&limit=1",
     "items" : [ {
       "album_type" : "single",
       "artists" : [ {
         "external_urls" : {
           "spotify" : "https://open.spotify.com/artist/6eUKZXaKkcviH0Ku9w2n3V"
         },
         "href" : "https://api.spotify.com/v1/artists/6eUKZXaKkcviH0Ku9w2n3V",
         "id" : "6eUKZXaKkcviH0Ku9w2n3V",
         "name" : "Ed Sheeran",
         "type" : "artist",
         "uri" : "spotify:artist:6eUKZXaKkcviH0Ku9w2n3V"
       }, {
         "external_urls" : {
           "spotify" : "https://open.spotify.com/artist/06HL4z0CvFAxyc27GXpf02"
         },
         "href" : "https://api.spotify.com/v1/artists/06HL4z0CvFAxyc27GXpf02",
         "id" : "06HL4z0CvFAxyc27GXpf02",
         "name" : "Taylor Swift",
         "type" : "artist",
         "uri" : "spotify:artist:06HL4z0CvFAxyc27GXpf02"
       } ],
       "available_markets" : [ "AD", "AE" ],
       "external_urls" : {
         "spotify" : "https://open.spotify.com/album/0vkAczpFKCazPKaoLtnBr0"
       },
       "href" : "https://api.spotify.com/v1/albums/0vkAczpFKCazPKaoLtnBr0",
       "id" : "0vkAczpFKCazPKaoLtnBr0",
       "images" : [ {
         "height" : 640,
         "url" : "https://i.scdn.co/image/ab67616d0000b27389aff4625958eac8d16535c7",
         "width" : 640
       }, {
         "height" : 300,
         "url" : "https://i.scdn.co/image/ab67616d00001e0289aff4625958eac8d16535c7",
         "width" : 300
       }, {
         "height" : 64,
         "url" : "https://i.scdn.co/image/ab67616d0000485189aff4625958eac8d16535c7",
         "width" : 64
       } ],
       "name" : "The Joker And The Queen (feat. Taylor Swift)",
       "release_date" : "2022-02-11",
       "release_date_precision" : "day",
       "total_tracks" : 1,
       "type" : "album",
       "uri" : "spotify:album:0vkAczpFKCazPKaoLtnBr0"
     } ],
     "limit" : 1,
     "next" : "https://api.spotify.com/v1/browse/new-releases?locale=en-US%2Cen%3Bq%3D0.9&offset=1&limit=1",
     "offset" : 0,
     "previous" : null,
     "total" : 100
   }
 }

 */
