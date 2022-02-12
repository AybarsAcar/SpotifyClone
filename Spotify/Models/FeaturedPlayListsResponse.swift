//
//  FeaturedPlayListsResponse.swift
//  Spotify
//
//  Created by Aybars Acar on 12/2/2022.
//

import Foundation

// MARK: - Response
struct FeaturedPlayListsResponse: Codable {
  let message: String
  let playlists: PlaylistsResponse
}

// MARK: - Playlists
struct PlaylistsResponse: Codable {
  let items: [PlayList]
}


// MARK: - Owner
struct Owner: Codable {
  let displayName: String
  let externalUrls: [String: String]
  let href: String
  let id: String
  let type: StringLiteralType
  let uri: String
  
  enum CodingKeys: String, CodingKey {
    case displayName = "display_name"
    case externalUrls = "external_urls"
    case href, id, type, uri
  }
}


// MARK: - Tracks
struct Tracks: Codable {
  let href: String
  let total: Int
}

enum ItemType: String, Codable {
  case playlist = "playlist"
}


/*
 {
   "message" : "Editor's picks",
   "playlists" : {
     "href" : "https://api.spotify.com/v1/browse/featured-playlists?timestamp=2022-02-12T02%3A14%3A27&offset=0&limit=50",
     "items" : [ {
       "collaborative" : false,
       "description" : "Gentle ambient piano to help you fall asleep.",
       "external_urls" : {
         "spotify" : "https://open.spotify.com/playlist/37i9dQZF1DWZd79rJ6a7lp"
       },
       "href" : "https://api.spotify.com/v1/playlists/37i9dQZF1DWZd79rJ6a7lp",
       "id" : "37i9dQZF1DWZd79rJ6a7lp",
       "images" : [ {
         "height" : null,
         "url" : "https://i.scdn.co/image/ab67706f00000003b70e0223f544b1faa2e95ed0",
         "width" : null
       } ],
       "name" : "Sleep",
       "owner" : {
         "display_name" : "Spotify",
         "external_urls" : {
           "spotify" : "https://open.spotify.com/user/spotify"
         },
         "href" : "https://api.spotify.com/v1/users/spotify",
         "id" : "spotify",
         "type" : "user",
         "uri" : "spotify:user:spotify"
       },
       "primary_color" : null,
       "public" : null,
       "snapshot_id" : "MTY0NDQxNjI3NCwwMDAwMDBkYzAwMDAwMTdlZGVkOTBlNmUwMDAwMDE2Y2Y2OTUyYjAw",
       "tracks" : {
         "href" : "https://api.spotify.com/v1/playlists/37i9dQZF1DWZd79rJ6a7lp/tracks",
         "total" : 208
       },
       "type" : "playlist",
       "uri" : "spotify:playlist:37i9dQZF1DWZd79rJ6a7lp"
     }, {
       "collaborative" : false,
       "description" : "Hip-Hop + R&B: Before. Anything. Else. Cover: Gunna",
       "external_urls" : {
         "spotify" : "https://open.spotify.com/playlist/37i9dQZF1DWX3387IZmjNa"
       },
       "href" : "https://api.spotify.com/v1/playlists/37i9dQZF1DWX3387IZmjNa",
       "id" : "37i9dQZF1DWX3387IZmjNa",
       "images" : [ {
         "height" : null,
         "url" : "https://i.scdn.co/image/ab67706f000000036d85e931004fa1c7417bd7d2",
         "width" : null
       } ],
       "name" : "B.A.E.",
       "owner" : {
         "display_name" : "Spotify",
         "external_urls" : {
           "spotify" : "https://open.spotify.com/user/spotify"
         },
         "href" : "https://api.spotify.com/v1/users/spotify",
         "id" : "spotify",
         "type" : "user",
         "uri" : "spotify:user:spotify"
       },
       "primary_color" : null,
       "public" : null,
       "snapshot_id" : "MTY0NDU5NTkwNCwwMDAwMDUwMzAwMDAwMTdlZTk4ZTAxMzUwMDAwMDE3ZWMxNDAyMmMz",
       "tracks" : {
         "href" : "https://api.spotify.com/v1/playlists/37i9dQZF1DWX3387IZmjNa/tracks",
         "total" : 50
       },
       "type" : "playlist",
       "uri" : "spotify:playlist:37i9dQZF1DWX3387IZmjNa"
     }, {
       "collaborative" : false,
       "description" : "Dreamy jams from the best bedroom producers. Cover: SALES",
       "external_urls" : {
         "spotify" : "https://open.spotify.com/playlist/37i9dQZF1DXcxvFzl58uP7"
       },
       "href" : "https://api.spotify.com/v1/playlists/37i9dQZF1DXcxvFzl58uP7",
       "id" : "37i9dQZF1DXcxvFzl58uP7",
       "images" : [ {
         "height" : null,
         "url" : "https://i.scdn.co/image/ab67706f0000000365454d58b8bf934ad9e08ab7",
         "width" : null
       } ],
       "name" : "Bedroom Pop",
       "owner" : {
         "display_name" : "Spotify",
         "external_urls" : {
           "spotify" : "https://open.spotify.com/user/spotify"
         },
         "href" : "https://api.spotify.com/v1/users/spotify",
         "id" : "spotify",
         "type" : "user",
         "uri" : "spotify:user:spotify"
       },
       "primary_color" : null,
       "public" : null,
       "snapshot_id" : "MTY0NDYzMjA1NywwMDAwMDAwMGQ0MWQ4Y2Q5OGYwMGIyMDRlOTgwMDk5OGVjZjg0Mjdl",
       "tracks" : {
         "href" : "https://api.spotify.com/v1/playlists/37i9dQZF1DXcxvFzl58uP7/tracks",
         "total" : 115
       },
       "type" : "playlist",
       "uri" : "spotify:playlist:37i9dQZF1DXcxvFzl58uP7"
     }, {
       "collaborative" : false,
       "description" : "Relax with deep house and electronica.",
       "external_urls" : {
         "spotify" : "https://open.spotify.com/playlist/37i9dQZF1DX0AZ24QB6TCx"
       },
       "href" : "https://api.spotify.com/v1/playlists/37i9dQZF1DX0AZ24QB6TCx",
       "id" : "37i9dQZF1DX0AZ24QB6TCx",
       "images" : [ {
         "height" : null,
         "url" : "https://i.scdn.co/image/ab67706f00000003507c9c9c47b0f2c88c9bbc88",
         "width" : null
       } ],
       "name" : "Afterhours",
       "owner" : {
         "display_name" : "Spotify",
         "external_urls" : {
           "spotify" : "https://open.spotify.com/user/spotify"
         },
         "href" : "https://api.spotify.com/v1/users/spotify",
         "id" : "spotify",
         "type" : "user",
         "uri" : "spotify:user:spotify"
       },
       "primary_color" : null,
       "public" : null,
       "snapshot_id" : "MTY0NDYzMjA1OCwwMDAwMDAwMGQ0MWQ4Y2Q5OGYwMGIyMDRlOTgwMDk5OGVjZjg0Mjdl",
       "tracks" : {
         "href" : "https://api.spotify.com/v1/playlists/37i9dQZF1DX0AZ24QB6TCx/tracks",
         "total" : 70
       },
       "type" : "playlist",
       "uri" : "spotify:playlist:37i9dQZF1DX0AZ24QB6TCx"
     }, {
       "collaborative" : false,
       "description" : "A mega mix of 75 favorites from the last few years! ",
       "external_urls" : {
         "spotify" : "https://open.spotify.com/playlist/37i9dQZF1DXbYM3nMM0oPk"
       },
       "href" : "https://api.spotify.com/v1/playlists/37i9dQZF1DXbYM3nMM0oPk",
       "id" : "37i9dQZF1DXbYM3nMM0oPk",
       "images" : [ {
         "height" : null,
         "url" : "https://i.scdn.co/image/ab67706f00000003db32a17c1f5291b19317b62e",
         "width" : null
       } ],
       "name" : "Mega Hit Mix",
       "owner" : {
         "display_name" : "Spotify",
         "external_urls" : {
           "spotify" : "https://open.spotify.com/user/spotify"
         },
         "href" : "https://api.spotify.com/v1/users/spotify",
         "id" : "spotify",
         "type" : "user",
         "uri" : "spotify:user:spotify"
       },
       "primary_color" : null,
       "public" : null,
       "snapshot_id" : "MTY0NDYzMjA2NywwMDAwMDAwMGQ0MWQ4Y2Q5OGYwMGIyMDRlOTgwMDk5OGVjZjg0Mjdl",
       "tracks" : {
         "href" : "https://api.spotify.com/v1/playlists/37i9dQZF1DXbYM3nMM0oPk/tracks",
         "total" : 75
       },
       "type" : "playlist",
       "uri" : "spotify:playlist:37i9dQZF1DXbYM3nMM0oPk"
     }, {
       "collaborative" : false,
       "description" : "The perfect playlist to just sit back and chill out with.",
       "external_urls" : {
         "spotify" : "https://open.spotify.com/playlist/37i9dQZF1DXci7j0DJQgGp"
       },
       "href" : "https://api.spotify.com/v1/playlists/37i9dQZF1DXci7j0DJQgGp",
       "id" : "37i9dQZF1DXci7j0DJQgGp",
       "images" : [ {
         "height" : null,
         "url" : "https://i.scdn.co/image/ab67706f00000003f32119fee4aa25dab786aca6",
         "width" : null
       } ],
       "name" : "Hanging Out & Relaxing",
       "owner" : {
         "display_name" : "Spotify",
         "external_urls" : {
           "spotify" : "https://open.spotify.com/user/spotify"
         },
         "href" : "https://api.spotify.com/v1/users/spotify",
         "id" : "spotify",
         "type" : "user",
         "uri" : "spotify:user:spotify"
       },
       "primary_color" : null,
       "public" : null,
       "snapshot_id" : "MTY0NDYzMjA1MSwwMDAwMDAwMGQ0MWQ4Y2Q5OGYwMGIyMDRlOTgwMDk5OGVjZjg0Mjdl",
       "tracks" : {
         "href" : "https://api.spotify.com/v1/playlists/37i9dQZF1DXci7j0DJQgGp/tracks",
         "total" : 100
       },
       "type" : "playlist",
       "uri" : "spotify:playlist:37i9dQZF1DXci7j0DJQgGp"
     }, {
       "collaborative" : false,
       "description" : "Hip-Hop classics from Interscope Records. Cover: Eminem",
       "external_urls" : {
         "spotify" : "https://open.spotify.com/playlist/37i9dQZF1DWVA1Gq4XHa6U"
       },
       "href" : "https://api.spotify.com/v1/playlists/37i9dQZF1DWVA1Gq4XHa6U",
       "id" : "37i9dQZF1DWVA1Gq4XHa6U",
       "images" : [ {
         "height" : null,
         "url" : "https://i.scdn.co/image/ab67706f00000003531c2ebb7f9e2c849e487997",
         "width" : null
       } ],
       "name" : "Gold School",
       "owner" : {
         "display_name" : "Spotify",
         "external_urls" : {
           "spotify" : "https://open.spotify.com/user/spotify"
         },
         "href" : "https://api.spotify.com/v1/users/spotify",
         "id" : "spotify",
         "type" : "user",
         "uri" : "spotify:user:spotify"
       },
       "primary_color" : null,
       "public" : null,
       "snapshot_id" : "MTY0NDU1NjM0NSwwMDAwMDBiZjAwMDAwMTdlZTczMjVmMDQwMDAwMDE3ZWMyZWJlNDhm",
       "tracks" : {
         "href" : "https://api.spotify.com/v1/playlists/37i9dQZF1DWVA1Gq4XHa6U/tracks",
         "total" : 50
       },
       "type" : "playlist",
       "uri" : "spotify:playlist:37i9dQZF1DWVA1Gq4XHa6U"
     }, {
       "collaborative" : false,
       "description" : "Pouring rain and occasional rolling thunder.",
       "external_urls" : {
         "spotify" : "https://open.spotify.com/playlist/37i9dQZF1DXbcPC6Vvqudd"
       },
       "href" : "https://api.spotify.com/v1/playlists/37i9dQZF1DXbcPC6Vvqudd",
       "id" : "37i9dQZF1DXbcPC6Vvqudd",
       "images" : [ {
         "height" : null,
         "url" : "https://i.scdn.co/image/ab67706f0000000393fe06c436d719d3f31107d0",
         "width" : null
       } ],
       "name" : "Night Rain",
       "owner" : {
         "display_name" : "Spotify",
         "external_urls" : {
           "spotify" : "https://open.spotify.com/user/spotify"
         },
         "href" : "https://api.spotify.com/v1/users/spotify",
         "id" : "spotify",
         "type" : "user",
         "uri" : "spotify:user:spotify"
       },
       "primary_color" : null,
       "public" : null,
       "snapshot_id" : "MTY0NDQyNzgwNSwwMDAwMDA1NzAwMDAwMTdlZGY4OTAzYTUwMDAwMDE3MGM0OWExMzVj",
       "tracks" : {
         "href" : "https://api.spotify.com/v1/playlists/37i9dQZF1DXbcPC6Vvqudd/tracks",
         "total" : 388
       },
       "type" : "playlist",
       "uri" : "spotify:playlist:37i9dQZF1DXbcPC6Vvqudd"
     }, {
       "collaborative" : false,
       "description" : "Unwind to these calm classical guitar pieces.",
       "external_urls" : {
         "spotify" : "https://open.spotify.com/playlist/37i9dQZF1DX0jgyAiPl8Af"
       },
       "href" : "https://api.spotify.com/v1/playlists/37i9dQZF1DX0jgyAiPl8Af",
       "id" : "37i9dQZF1DX0jgyAiPl8Af",
       "images" : [ {
         "height" : null,
         "url" : "https://i.scdn.co/image/ab67706f000000038ed1a5002b96c2ea882541b2",
         "width" : null
       } ],
       "name" : "Peaceful Guitar",
       "owner" : {
         "display_name" : "Spotify",
         "external_urls" : {
           "spotify" : "https://open.spotify.com/user/spotify"
         },
         "href" : "https://api.spotify.com/v1/users/spotify",
         "id" : "spotify",
         "type" : "user",
         "uri" : "spotify:user:spotify"
       },
       "primary_color" : null,
       "public" : null,
       "snapshot_id" : "MTY0MzcxNTYwNSwwMDAwMDBhYjAwMDAwMTdlYjUxNWIyMmIwMDAwMDE2ZDE1MzFlYjZl",
       "tracks" : {
         "href" : "https://api.spotify.com/v1/playlists/37i9dQZF1DX0jgyAiPl8Af/tracks",
         "total" : 202
       },
       "type" : "playlist",
       "uri" : "spotify:playlist:37i9dQZF1DX0jgyAiPl8Af"
     }, {
       "collaborative" : false,
       "description" : "Relax and unwind with chill, ambient music.",
       "external_urls" : {
         "spotify" : "https://open.spotify.com/playlist/37i9dQZF1DX3Ogo9pFvBkY"
       },
       "href" : "https://api.spotify.com/v1/playlists/37i9dQZF1DX3Ogo9pFvBkY",
       "id" : "37i9dQZF1DX3Ogo9pFvBkY",
       "images" : [ {
         "height" : null,
         "url" : "https://i.scdn.co/image/ab67706f00000003fbcb321e14b5b643f21bf3aa",
         "width" : null
       } ],
       "name" : "Ambient Relaxation",
       "owner" : {
         "display_name" : "Spotify",
         "external_urls" : {
           "spotify" : "https://open.spotify.com/user/spotify"
         },
         "href" : "https://api.spotify.com/v1/users/spotify",
         "id" : "spotify",
         "type" : "user",
         "uri" : "spotify:user:spotify"
       },
       "primary_color" : null,
       "public" : null,
       "snapshot_id" : "MTY0MzM4NjM3MSwwMDAwMDA3MzAwMDAwMTdlYTE3NWZjNjEwMDAwMDE2ZDE1MGZmMDc4",
       "tracks" : {
         "href" : "https://api.spotify.com/v1/playlists/37i9dQZF1DX3Ogo9pFvBkY/tracks",
         "total" : 308
       },
       "type" : "playlist",
       "uri" : "spotify:playlist:37i9dQZF1DX3Ogo9pFvBkY"
     }, {
       "collaborative" : false,
       "description" : "A new year ahead with beats to chill, relax, study, and focus... ",
       "external_urls" : {
         "spotify" : "https://open.spotify.com/playlist/37i9dQZF1DWWQRwui0ExPn"
       },
       "href" : "https://api.spotify.com/v1/playlists/37i9dQZF1DWWQRwui0ExPn",
       "id" : "37i9dQZF1DWWQRwui0ExPn",
       "images" : [ {
         "height" : null,
         "url" : "https://i.scdn.co/image/ab67706f0000000380709947e59a4e8bf1c36f8f",
         "width" : null
       } ],
       "name" : "lofi beats",
       "owner" : {
         "display_name" : "Spotify",
         "external_urls" : {
           "spotify" : "https://open.spotify.com/user/spotify"
         },
         "href" : "https://api.spotify.com/v1/users/spotify",
         "id" : "spotify",
         "type" : "user",
         "uri" : "spotify:user:spotify"
       },
       "primary_color" : null,
       "public" : null,
       "snapshot_id" : "MTY0NDYzMjA1NiwwMDAwMDAwMGQ0MWQ4Y2Q5OGYwMGIyMDRlOTgwMDk5OGVjZjg0Mjdl",
       "tracks" : {
         "href" : "https://api.spotify.com/v1/playlists/37i9dQZF1DWWQRwui0ExPn/tracks",
         "total" : 812
       },
       "type" : "playlist",
       "uri" : "spotify:playlist:37i9dQZF1DWWQRwui0ExPn"
     }, {
       "collaborative" : false,
       "description" : "Check out these throwback R&B jams from the first decade of the 21st century. Cover: Mary J Blige ",
       "external_urls" : {
         "spotify" : "https://open.spotify.com/playlist/37i9dQZF1DWYmmr74INQlb"
       },
       "href" : "https://api.spotify.com/v1/playlists/37i9dQZF1DWYmmr74INQlb",
       "id" : "37i9dQZF1DWYmmr74INQlb",
       "images" : [ {
         "height" : null,
         "url" : "https://i.scdn.co/image/ab67706f00000003dca045d605268c68f728e3a9",
         "width" : null
       } ],
       "name" : "I Love My '00s R&B",
       "owner" : {
         "display_name" : "Spotify",
         "external_urls" : {
           "spotify" : "https://open.spotify.com/user/spotify"
         },
         "href" : "https://api.spotify.com/v1/users/spotify",
         "id" : "spotify",
         "type" : "user",
         "uri" : "spotify:user:spotify"
       },
       "primary_color" : null,
       "public" : null,
       "snapshot_id" : "MTY0NDYzMjA1NiwwMDAwMDAwMGQ0MWQ4Y2Q5OGYwMGIyMDRlOTgwMDk5OGVjZjg0Mjdl",
       "tracks" : {
         "href" : "https://api.spotify.com/v1/playlists/37i9dQZF1DWYmmr74INQlb/tracks",
         "total" : 40
       },
       "type" : "playlist",
       "uri" : "spotify:playlist:37i9dQZF1DWYmmr74INQlb"
     } ],
     "limit" : 50,
     "next" : null,
     "offset" : 0,
     "previous" : null,
     "total" : 12
   }
 }

 */
