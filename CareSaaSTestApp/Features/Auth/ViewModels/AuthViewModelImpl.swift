//
//  AuthViewModelImpl.swift
//  CareSaaSTestApp
//
//  Created by MacBook on 6/16/24.
//

import Foundation
import SwiftUI

final class AuthViewModelImpl: ObservableObject, IAuthViewModel {
   
   private let remoteDatasource: IAuthRemoteDatasource
   
   @ObservedObject var preferenceStore: PreferenceStore
   
   init(authRemote: IAuthRemoteDatasource = AuthRemoteDatasourceImpl(), preferenceStore: PreferenceStore = PreferenceStore()) {
      self.remoteDatasource = authRemote
      self.preferenceStore = preferenceStore
   }
   
   @Published var btnText = "Next"
   @Published var emailText = ""
   @Published var usernameText = ""
   @Published var passwordText = ""
   @Published var errorMessage = ""
   @Published var hasError = false
   @Published var didSignIn = false
   @Published var showAlert = false
   @Published var isLoading = false
   @Published var successMessage = ""
   @Published var showSuccessAlert = false
   @Published var didResetPassword = false
   @Published var isPasswordVisible = false
   @Published var startForgotPassword = false
   @Published var didVerifyUsernameForPasswordReset = false
   @Published var subtitleText = "Enter your email to get started"
   
   var userId: String {
      get { preferenceStore.userId }
      set { preferenceStore.userId = newValue }
   }
   
   var accessToken: String {
      get { preferenceStore.accessToken }
      set { preferenceStore.accessToken = newValue }
   }
   
   var isSignedIn: Bool {
      get { preferenceStore.isSignedIn }
      set { preferenceStore.isSignedIn = newValue }
   }
   
   var isRememberMeChecked: Bool {
      get { preferenceStore.isRememberMeChecked }
      set { preferenceStore.isRememberMeChecked = newValue }
   }
   
   var shortCode: String {
      get { preferenceStore.shortCode }
      set { preferenceStore.shortCode = newValue }
   }
   
   var assignee: Int {
      get { preferenceStore.assignee }
      set { preferenceStore.assignee = newValue }
   }
   
   func performSignIn(username: String, password: String) {
      Task(priority: .medium) {
         try await self.signIn(username: username, password: password)
      }
   }
   
   func performforgotPassword(username: String) {
      Task(priority: .medium) {
         try await self.forgotPassword(username: username)
      }
   }
   
   func performResetPassword(password: String) {
      Task(priority: .medium) {
         try await self.resetPassword(password: password)
      }
   }
   
   func signOut() {
      isSignedIn = false
   }
   
   func toggleRememberMe() {
      isRememberMeChecked.toggle()
   }
   
}

extension AuthViewModelImpl {
   
   @MainActor
   func signIn(username: String, password: String) async throws {
      isLoading.toggle()
      
      do {
         let response = try await remoteDatasource.signIn(username: username, password: password)
         
         isLoading.toggle()
         didSignIn.toggle()
         accessToken = response.data?.userToken?.accessToken ?? ""
         shortCode = response.data?.user?.organization ?? ""
         assignee = response.data?.user?.userID?.int ?? 0
      } catch let error as NetworkError {
         isLoading.toggle()
         hasError.toggle()
         showAlert.toggle()
         errorMessage = error.errorDescription ?? error.localizedDescription
         kprint("\(errorMessage)", logType: .fault)
      } catch {
         isLoading.toggle()
         hasError.toggle()
         showAlert.toggle()
         errorMessage = error.localizedDescription
         kprint("An unexpected error occurred", logType: .fault)
      }
   }
   
   func forgotPassword(username: String) async throws {
      isLoading.toggle()
      
      do {
         let response = try await remoteDatasource.forgotPassword(username: username)
         
         btnText = "Continue"
         subtitleText = "Enter a new password"
         isLoading.toggle()
         didVerifyUsernameForPasswordReset.toggle()
         userId = response.data?.userId ?? ""
      } catch let error as NetworkError {
         isLoading.toggle()
         hasError.toggle()
         showAlert.toggle()
         errorMessage = error.errorDescription ?? error.localizedDescription
         kprint("\(errorMessage)", logType: .fault)
      } catch {
         isLoading.toggle()
         hasError.toggle()
         showAlert.toggle()
         errorMessage = error.localizedDescription
         kprint("An unexpected error occurred", logType: .fault)
      }
   }
   
   func resetPassword(password: String) async throws {
      isLoading.toggle()
      
      do {
         let response = try await remoteDatasource.resetPassword(password: password, userId: preferenceStore.userId)
         
         btnText = "Continue"
         subtitleText = "Enter a new password"
         isLoading.toggle()
         showSuccessAlert.toggle()
         successMessage = response.message.orEmpty
      } catch let error as NetworkError {
         isLoading.toggle()
         hasError.toggle()
         showAlert.toggle()
         errorMessage = error.errorDescription ?? error.localizedDescription
         kprint("\(errorMessage)", logType: .fault)
      } catch {
         isLoading.toggle()
         hasError.toggle()
         showAlert.toggle()
         errorMessage = error.localizedDescription
         kprint("An unexpected error occurred", logType: .fault)
      }
   }
   
}
