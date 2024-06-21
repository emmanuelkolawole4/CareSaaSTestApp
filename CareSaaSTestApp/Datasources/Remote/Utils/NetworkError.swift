//
//  NetworkError.swift
//  GitHubRepos
//
//  Created by Isaac Iniongun on 27/11/2023.
//

import Foundation

enum NetworkError: Error {
   case invalidURL
   case requestFailed
   case errorCode(Int)
   case serverError(code: Int, message: String)
   case noInternetConnection
   case decodingFailed
   case invalidDataPrettyJson
}

extension NetworkError: LocalizedError {
   var errorDescription: String? {
      switch self {
      case .invalidURL:
         return "Invalid url, confirm full URL is correct and try again"
      case .requestFailed:
         return "Request failed"
      case .errorCode(let code):
         return "Error code:- \(code) - Something went wrong"
      case .serverError(let code, let message):
         return "\(message)"
      case .noInternetConnection:
         return "No internet connection, check your internet and try again"
      case .decodingFailed:
         return "Failed to decode model from the service"
      case .invalidDataPrettyJson:
         return "Error converting to pretty json"
      }
   }
}
