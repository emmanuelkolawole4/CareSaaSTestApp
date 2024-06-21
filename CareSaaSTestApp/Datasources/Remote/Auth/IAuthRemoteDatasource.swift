//
//  IAuthRemoteDatasource.swift
//  CareSaaSTestApp
//
//  Created by MacBook on 6/16/24.
//

import Foundation

protocol IAuthRemoteDatasource {
   
   func signIn(username: String, password: String) async throws -> NetworkResponse<LoginResponse>
   
   func forgotPassword(username: String) async throws -> NetworkResponse<ForgotPasswordResponse>
   
   func resetPassword(password: String, userId: String) async throws -> NetworkResponse<BlankNetworkResponse>
   
}
