//
//  Endpoint.swift
//  GitHubRepos
//
//  Created by Isaac Iniongun on 27/11/2023.
//

import Foundation

enum Endpoint {
   case signin
   case forgotPassword
   case resetPassword(userId: String)
   case getServiceUserTasks(shortCode: String, careHomeId: Int, assignee: Int)
   case invalidURL
   
   private var kpath: String {
      switch self {
      case .signin:
         return "auth/login"
      case .forgotPassword:
         return "auth/forgotPassword"
      case .resetPassword(let userId):
         return "auth/\(userId)/resetPassword"
      case .getServiceUserTasks(let shortCode, let careHomeId, let assignee):
         return "tasks/\(shortCode)/careHome/\(careHomeId)"
      case .invalidURL:
         return ""
      }
   }
   
   var path: String {
      switch self {
      case .invalidURL:
         return "\(Bundle.main.baseURL)"
      default:
         return "\(Bundle.main.baseURL)\(kpath)"
      }
   }
}
