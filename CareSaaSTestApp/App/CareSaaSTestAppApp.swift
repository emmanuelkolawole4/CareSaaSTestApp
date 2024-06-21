//
//  CareSaaSTestAppApp.swift
//  CareSaaSTestApp
//
//  Created by MacBook on 6/16/24.
//

import SwiftUI

@main
struct CareSaaSTestAppApp: App {
   
   @StateObject private var preferenceStore = PreferenceStore()
   
   var body: some Scene {
      WindowGroup {
         if preferenceStore.isSignedIn {
            MainContentScreen()
         } else {
            SignInView()
               .environmentObject(preferenceStore)
         }
      }
   }
}
