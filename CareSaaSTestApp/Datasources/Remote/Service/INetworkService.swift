//
//  INetworkService.swift
//  CareSaaSTestApp
//
//  Created by MacBook on 6/16/24.
//

import Foundation

protocol INetworkService {
   
   func makeRequest<T: Codable>(
      endpoint: Endpoint,
      method: HTTPMethod,
      parameters: Parameters?,
      headers: [String: String]?,
      responseType: T.Type
   ) async throws -> T
}
