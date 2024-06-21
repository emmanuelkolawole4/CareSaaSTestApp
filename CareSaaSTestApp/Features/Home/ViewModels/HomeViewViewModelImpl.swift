//
//  HomeViewViewModelImpl.swift
//  CareSaaSTestApp
//
//  Created by MacBook on 6/17/24.
//

import Foundation
import SwiftUI

final class HomeViewViewModelImpl: ObservableObject, IHomeViewViewModel {
   
   private let remoteDatasource: IHomeRemoteDatasource
   
   init(homeRemote: IHomeRemoteDatasource = HomeRemoteDatasourceImpl(), preferenceStore: PreferenceStore = PreferenceStore()) {
      self.remoteDatasource = homeRemote
      self.preferenceStore = preferenceStore
   }
   
   @Published var errorMessage = ""
   @Published var hasError = false
   @Published var showAlert = false
   @Published var isLoading = false
   @Published var clockedIn = false
   @Published var didGetServiceUserTasks = false
   @Published var serviceUserTasks: [ServiceUserTask] = []
   @Published var selectedContent: TaskContent = .medication
   
   @ObservedObject var preferenceStore: PreferenceStore
   
   var accessToken: String {
      get { preferenceStore.accessToken }
      set { preferenceStore.accessToken = newValue }
   }
   
   func toggleClockIn() {
      clockedIn.toggle()
   }
   
   func performGetServiceUserTasks() {
      Task(priority: .medium) {
         try await self.getServiceUserTasks()
      }
   }
   
}

extension HomeViewViewModelImpl {
   
   @MainActor
   func getServiceUserTasks() async throws {
      isLoading.toggle()
      
      do {
         let response = try await remoteDatasource.getServiceUserTasks(
            shortCode: preferenceStore.shortCode,
            careHomeId: preferenceStore.careHomeId,
            assignee: preferenceStore.assignee,
            accessToken: preferenceStore.accessToken
         )
         
         serviceUserTasks = response.data ?? []
         isLoading.toggle()
         didGetServiceUserTasks.toggle()
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
