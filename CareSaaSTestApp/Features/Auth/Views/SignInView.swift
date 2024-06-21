//
//  SignInView.swift
//  CareSaaSTestApp
//
//  Created by MacBook on 6/16/24.
//

import SwiftUI

struct SignInView: View {
   
   @Environment(\.dismiss) var dismiss
   @Environment(\.presentationMode) var presentationMode
   @StateObject private var viewModel: AuthViewModelImpl
   @EnvironmentObject var preferenceStore: PreferenceStore
   
   init() {
      let vm = AuthViewModelImpl(preferenceStore: PreferenceStore())
      _viewModel = StateObject(wrappedValue: vm)
   }
   
   var body: some View {
      NavigationStack {
         VStack(alignment: .leading) {
            Spacer()
            welcomeText
            inputFields
            forgotPasswordView
            signInButton
            contactSupportText
            Spacer()
            termsAndConditionsText
         }
         .padding(.horizontal)
         .onTapGesture { UIApplication.shared.endEditiong() }
         .navigationDestination(isPresented: $viewModel.startForgotPassword) {
            ForgotPasswordView()
               .environmentObject(viewModel)
         }
         .navigationDestination(isPresented: $viewModel.didSignIn) {
            MainContentScreen()
         }
      }
      .alert("Error authenticating ⚠️", isPresented: $viewModel.showAlert) {
         Button("Close") {}
      } message: {
         Text(viewModel.errorMessage)
      }
   }
}

private extension SignInView {
   
   var welcomeText: some View {
      VStack(alignment: .leading, spacing: 8) {
         HStack {
            Text("Welcome back!👋")
               .font(.system(size: 40, weight: .bold))
               .foregroundStyle(Color.primaryTextColor)
            
            Spacer()
         }
         
         Text("Fill your details to get started")
            .font(.system(size: 16, weight: .regular))
            .foregroundStyle(Color.secondaryTextColor)
      }
      .padding(.bottom, 40)
   }
   
   var inputFields: some View {
      VStack(spacing: 16) {
         TextField("Username", text: $viewModel.usernameText)
            .padding()
            .background(
               RoundedRectangle(cornerRadius: 8)
                  .strokeBorder(Color.secondaryTextColor, lineWidth: 0.8)
            )
         
         HStack {
            if viewModel.isPasswordVisible {
               TextField("Password", text: $viewModel.passwordText)
            } else {
               SecureField("Password", text: $viewModel.passwordText)
            }
            
            Image(systemName: viewModel.isPasswordVisible ? "eye.slash" : "eye")
               .foregroundStyle(Color.secondaryTextColor)
               .onTapGesture { viewModel.isPasswordVisible.toggle() }
         }
         .padding()
         .overlay (
            RoundedRectangle(cornerRadius: 8)
               .strokeBorder(Color.secondaryTextColor, lineWidth: 0.8)
         )
      }
      .textInputAutocapitalization(.never)
      .padding(.bottom)
   }
   
   var forgotPasswordView: some View {
      HStack {
         Label(
            title: { Text("Remember me").foregroundStyle(Color.secondaryTextColor) },
            icon: { Image(systemName: viewModel.isRememberMeChecked ? "checkmark.square.fill" : "square").foregroundStyle(viewModel.isRememberMeChecked ? Color.accentColor : .gray) }
         )
         .onTapGesture {
            viewModel.toggleRememberMe()
         }
         
         Spacer()
         
         Text("Forgot Password?")
            .font(.system(size: 16, weight: .regular))
            .foregroundStyle(Color.appRedColor)
            .onTapGesture { viewModel.startForgotPassword.toggle() }
      }
      .padding(.bottom, 30)
   }
   
   var signInButton: some View {
      BaseButton(buttonText: "Sign In", loadingState: viewModel.isLoading, validationsSatisfied: validateFields()) {
         viewModel.performSignIn(username: viewModel.usernameText, password: viewModel.passwordText)
      }
      .padding(.bottom, 30)
   }
   
   var contactSupportText: some View {
      HStack {
         Spacer()
         Text("Don't have an account?")
         Text("Contact Support")
            .foregroundStyle(Color.accentColor)
         Spacer()
      }
      .font(.system(size: 16, weight: .regular))
   }
   
   var termsAndConditionsText: some View {
      let firstPart = AttributedString("By clicking ‘Sign in’ above you agree to Arocare’s ")
      var secondPart = AttributedString("Terms & Conditions ")
      var thirdPart = AttributedString("Privacy Policy.")
      secondPart.foregroundColor = Color.accentColor
      thirdPart.foregroundColor = Color.accentColor
      
      return Text(firstPart + secondPart + "and " + thirdPart)
         .padding()
         .font(.system(size: 11.5, weight: .regular))
         .multilineTextAlignment(.center)
      
   }
   
   func validateFields() -> Bool {
      viewModel.usernameText.isNotEmpty && viewModel.passwordText.isNotEmpty
   }
   
   func handleDismiss() {
      if #available(iOS 15, *) {
         dismiss()
      } else {
         presentationMode.wrappedValue.dismiss()
      }
   }
   
}

#Preview {
   SignInView()
      .environmentObject(PreferenceStore.init())
}
