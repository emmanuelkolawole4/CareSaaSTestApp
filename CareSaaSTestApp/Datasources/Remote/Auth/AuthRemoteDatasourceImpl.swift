//
//  AuthRemoteDatasourceImpl.swift
//  CareSaaSTestApp
//
//  Created by MacBook on 6/16/24.
//

import Foundation

final class AuthRemoteDatasourceImpl: IAuthRemoteDatasource {
   
   private let service: INetworkService
   
   init(service: INetworkService = NetworkServiceImpl()) {
      self.service = service
   }
   
   func signIn(username: String, password: String) async throws -> NetworkResponse<LoginResponse> {
      try await service.makeRequest(
         endpoint: .signin,
         method: .post,
         parameters: [ "userName": username, "password": password ],
         headers: [ "Content-Type": "application/json" ],
         responseType: NetworkResponse<LoginResponse>.self
      )
   }
   
   func forgotPassword(username: String) async throws -> NetworkResponse<ForgotPasswordResponse> {
      try await service.makeRequest(
         endpoint: .forgotPassword,
         method: .post,
         parameters: [ "userName": username ],
         headers: [
            "Content-Type": "application/json"
         ],
         responseType: NetworkResponse<ForgotPasswordResponse>.self
      )
   }
   
   func resetPassword(password: String, userId: String) async throws -> NetworkResponse<BlankNetworkResponse> {
      try await service.makeRequest(
         endpoint: .resetPassword(userId: userId),
         method: .post,
         parameters: [ "password": password ],
         headers: [
            "Content-Type": "application/json"
         ],
         responseType: NetworkResponse<BlankNetworkResponse>.self
      )
   }
   
}
