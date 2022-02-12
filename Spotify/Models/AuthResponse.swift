//
//  AuthResponse.swift
//  Spotify
//
//  Created by Aybars Acar on 10/2/2022.
//

import Foundation

struct AuthResponse: Codable {
  let access_token: String
  let expires_in: Int
  let refresh_token: String?
  let scope: String
  let token_type: String
}


/*
 {
     "access_token" = "BQAnT6JqEGPpaplxlHtXlT4onCeOk4B7DZQAiDmbGX5DR7ZGTIu_tMdEHCZwfe7ts61Y55gbOx7nA6UyCZWLzVpewxW1V3DY-BgVNdGgChZy_LiCLa7GQJ60QlKe7L-LaD4sD8w2OgOR1ewj06eZ1t5g3kygk7Mw";
     "expires_in" = 3600;
     "refresh_token" = AQDHqBESYAMcmQoRJcMz1dkPy74uZ8u4SMPeVEkczpyEr6kHjKCeXrgGOLxBxdYtfEN9UQuvf5jafc45CBNtDkfR2s1rurqTq0BArsJTNIqmH3WLYecvQ6fTMYl7ZJtlTrc;
     scope = "user-read-private";
     "token_type" = Bearer;
 }
 */

