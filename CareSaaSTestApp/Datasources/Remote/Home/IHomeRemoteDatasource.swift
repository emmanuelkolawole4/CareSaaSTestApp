//
//  IHomeRemoteDatasource.swift
//  CareSaaSTestApp
//
//  Created by MacBook on 6/18/24.
//

import Foundation

protocol IHomeRemoteDatasource {
   
   func getServiceUserTasks(shortCode: String, careHomeId: Int, assignee: Int, accessToken: String) async throws -> NetworkResponse<[ServiceUserTask]>
   
}
