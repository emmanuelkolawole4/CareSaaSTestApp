//
//  NetworkResponse.swift
//  CareSaaSTestApp
//
//  Created by MacBook on 6/16/24.
//

import Foundation

// MARK: - NetworkResponse
//struct NetworkResponse<T> {
//
//   let decodedObject: T
//   let rawData: Data
//
//}

// MARK: - NetworkResponse
struct NetworkResponse<T: Codable>: Codable {
   
   let status, message: String?
   let code: Int?
   let data: T?
   
}

// MARK: - BlankNetworkResponse
struct BlankNetworkResponse: Codable {
   
   let status, message: String?
   let code: Int?
   
}

// MARK: - ServerResponse
struct ServerResponse: Codable {
   
   let status, message: String?
   let code: Int?
   
}

struct ErrorResponseElement: Codable {
   
   let message, field: String?
   
}

// MARK: - LoginResponse
struct LoginResponse: Codable {
   
   let user: User?
   let userToken: UserToken?
   
}

// MARK: - User
struct User: Codable {
   
   let groups: [String]?
   let emailVerified: Bool?
   let realmAccess: RealmAccess?
   let sub, organization, name, email, lastRole: String?
   let preferredUsername, givenName, familyName, userID: String?
   
   enum CodingKeys: String, CodingKey {
      case sub
      case emailVerified = "email_verified"
      case realmAccess = "realm_access"
      case organization, name, groups
      case preferredUsername = "preferred_username"
      case givenName = "given_name"
      case familyName = "family_name"
      case userID = "userId"
      case email, lastRole
   }
   
}

// MARK: - RealmAccess
struct RealmAccess: Codable {
   
   let roles: [String]?
   
}

// MARK: - UserToken
struct UserToken: Codable {
   
   let accessToken, refreshToken: String?
   
   enum CodingKeys: String, CodingKey {
      case accessToken = "access_token"
      case refreshToken = "refresh_token"
   }
   
}

// MARK: - ForgotPassword
struct ForgotPasswordResponse: Codable {
   
   let userId: String?
   
}


// MARK: - ServiceUserTask
struct ServiceUserTask: Codable {
    let taskId, taskType, timeOfDay, taskGroup: String?
    let priority, taskDetailRef, hourOfDay: String?
   let supportPersonnel, taskScheduleId: String?
   let taskAssignments: [TaskAssignment]?
   let noSupportPersonnel, userId: Int?
    let isAssigned: Bool?

}

// MARK: - TaskAssignment
struct TaskAssignment: Codable {
   let assignee: Assignee?
   let assignmentStatus: String?
}

// MARK: - Assignee
struct Assignee: Codable {
    let userId: Int
    let firstName, lastName: String
}
