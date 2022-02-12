//
//  UserProfile.swift
//  Spotify
//
//  Created by Aybars Acar on 9/2/2022.
//

import Foundation

struct UserProfile: Codable {
  let country: String
  let display_name: String
  let email: String
  let explicit_content: [String: Bool]
  let external_urls: [String: String]
  let id: String
  let product: String
  let images: [APIImage]
}


/*
 {
     country = AU;
     "display_name" = Aybars;
     email = "aybars.dev@gmail.com";
     "explicit_content" =     {
         "filter_enabled" = 0;
         "filter_locked" = 0;
     };
     "external_urls" =     {
         spotify = "https://open.spotify.com/user/31lbpik452y32274etxifwfa7mbe";
     };
     followers =     {
         href = "<null>";
         total = 0;
     };
     href = "https://api.spotify.com/v1/users/31lbpik452y32274etxifwfa7mbe";
     id = 31lbpik452y32274etxifwfa7mbe;
     images =     (
     );
     product = open;
     type = user;
     uri = "spotify:user:31lbpik452y32274etxifwfa7mbe";
 }
 {
     country = AU;
     "display_name" = Aybars;
     email = "aybars.dev@gmail.com";
     "explicit_content" =     {
         "filter_enabled" = 0;
         "filter_locked" = 0;
     };
     "external_urls" =     {
         spotify = "https://open.spotify.com/user/31lbpik452y32274etxifwfa7mbe";
     };
     followers =     {
         href = "<null>";
         total = 0;
     };
     href = "https://api.spotify.com/v1/users/31lbpik452y32274etxifwfa7mbe";
     id = 31lbpik452y32274etxifwfa7mbe;
     images =     (
     );
     product = open;
     type = user;
     uri = "spotify:user:31lbpik452y32274etxifwfa7mbe";
 }
 {
     country = AU;
     "display_name" = Aybars;
     email = "aybars.dev@gmail.com";
     "explicit_content" =     {
         "filter_enabled" = 0;
         "filter_locked" = 0;
     };
     "external_urls" =     {
         spotify = "https://open.spotify.com/user/31lbpik452y32274etxifwfa7mbe";
     };
     followers =     {
         href = "<null>";
         total = 0;
     };
     href = "https://api.spotify.com/v1/users/31lbpik452y32274etxifwfa7mbe";
     id = 31lbpik452y32274etxifwfa7mbe;
     images =     (
     );
     product = open;
     type = user;
     uri = "spotify:user:31lbpik452y32274etxifwfa7mbe";
 }
 {
     country = AU;
     "display_name" = Aybars;
     email = "aybars.dev@gmail.com";
     "explicit_content" =     {
         "filter_enabled" = 0;
         "filter_locked" = 0;
     };
     "external_urls" =     {
         spotify = "https://open.spotify.com/user/31lbpik452y32274etxifwfa7mbe";
     };
     followers =     {
         href = "<null>";
         total = 0;
     };
     href = "https://api.spotify.com/v1/users/31lbpik452y32274etxifwfa7mbe";
     id = 31lbpik452y32274etxifwfa7mbe;
     images =     (
     );
     product = open;
     type = user;
     uri = "spotify:user:31lbpik452y32274etxifwfa7mbe";
 }
 {
     country = AU;
     "display_name" = Aybars;
     email = "aybars.dev@gmail.com";
     "explicit_content" =     {
         "filter_enabled" = 0;
         "filter_locked" = 0;
     };
     "external_urls" =     {
         spotify = "https://open.spotify.com/user/31lbpik452y32274etxifwfa7mbe";
     };
     followers =     {
         href = "<null>";
         total = 0;
     };
     href = "https://api.spotify.com/v1/users/31lbpik452y32274etxifwfa7mbe";
     id = 31lbpik452y32274etxifwfa7mbe;
     images =     (
     );
     product = open;
     type = user;
     uri = "spotify:user:31lbpik452y32274etxifwfa7mbe";
 }

 */
 
