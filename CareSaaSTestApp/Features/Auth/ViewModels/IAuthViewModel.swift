//
//  IAuthViewModel.swift
//  CareSaaSTestApp
//
//  Created by MacBook on 6/16/24.
//

import Foundation

protocol IAuthViewModel: ObservableObject {
   
   var isSignedIn: Bool { get set }
   
   var isRememberMeChecked: Bool { get set }
   
   func toggleRememberMe()
   
   func performSignIn(username: String, password: String)
   
   func performforgotPassword(username: String)
   
   func performResetPassword(password: String)
   
   func signOut()
   
}
