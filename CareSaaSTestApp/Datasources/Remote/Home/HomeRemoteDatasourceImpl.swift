//
//  HomeRemoteDatasourceImpl.swift
//  CareSaaSTestApp
//
//  Created by MacBook on 6/18/24.
//

import Foundation

final class HomeRemoteDatasourceImpl: IHomeRemoteDatasource {
   
   private let service: INetworkService
   
   init(service: INetworkService = NetworkServiceImpl()) {
      self.service = service
   }
   
   func getServiceUserTasks(shortCode: String, careHomeId: Int, assignee: Int, accessToken: String) async throws -> NetworkResponse<[ServiceUserTask]> {
      try await service.makeRequest(
         endpoint: .getServiceUserTasks(shortCode: shortCode, careHomeId: careHomeId, assignee: assignee),
         method: .get,
         parameters: [ "assignee": assignee ],
         headers: [
            "Content-Type": "application/json",
            "Authorization": "Bearer " + accessToken
         ],
         responseType: NetworkResponse<[ServiceUserTask]>.self
      )
   }
}

