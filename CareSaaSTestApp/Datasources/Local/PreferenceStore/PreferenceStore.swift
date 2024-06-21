//
//  PreferenceStore.swift
//  CareSaaSTestApp
//
//  Created by MacBook on 6/16/24.
//

import Foundation
import SwiftUI

final class PreferenceStore: ObservableObject {
   
   @AppStorage(.userId) var userId = ""
   @AppStorage(.token) var token = ""
   @AppStorage(.assignee) var assignee = 0
   @AppStorage(.shortCode) var shortCode = ""
   @AppStorage(.careHomeId) var careHomeId = 2
   @AppStorage(.accessToken) var accessToken = ""
   @AppStorage(.isSignedIn) var isSignedIn = false
   @AppStorage(.isRememberMeChecked) var isRememberMeChecked = false
   
}
