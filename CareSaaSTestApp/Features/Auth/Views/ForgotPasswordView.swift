//
//  ForgotPasswordView.swift
//  CareSaaSTestApp
//
//  Created by MacBook on 6/16/24.
//

import SwiftUI

struct ForgotPasswordView: View {
   
   @EnvironmentObject var viewModel: AuthViewModelImpl
   
    var body: some View {
       VStack(alignment: .leading) {
          Spacer()
          welcomeText
          inputFields
          signInButton
          Spacer()
       }
       .padding(.horizontal)
       .onTapGesture { UIApplication.shared.endEditiong() }
       .onDisappear { 
          viewModel.usernameText = ""
          viewModel.passwordText = ""
          viewModel.btnText = "Next"
          viewModel.subtitleText = "Enter your email to get started"
          if viewModel.didVerifyUsernameForPasswordReset {
             viewModel.didVerifyUsernameForPasswordReset.toggle()
          }
       }
       .alert(isPresented: $viewModel.showSuccessAlert) {
           Alert(
               title: Text("✅ \(viewModel.successMessage)"),
               message: Text("Tap the OK button to login"),
               dismissButton: .default(Text("OK"), action: {
                  viewModel.didResetPassword = true
               })
           )
       }
       .fullScreenCover(isPresented: $viewModel.didResetPassword) {
          SignInView()
       }
    }
}

private extension ForgotPasswordView {
   
   var welcomeText: some View {
      VStack(alignment: .leading, spacing: 8) {
         HStack {
            Text("Reset Password")
               .font(.system(size: 40, weight: .bold))
               .foregroundStyle(Color.primaryTextColor)
            
            Spacer()
         }
         
         Text(viewModel.subtitleText)
            .font(.system(size: 16, weight: .regular))
            .foregroundStyle(Color.secondaryTextColor)
      }
      .padding(.bottom, 40)
   }
   
   var inputFields: some View {
      VStack(spacing: 16) {
         TextField("Username", text: $viewModel.usernameText)
            .padding()
            .overlay(
               RoundedRectangle(cornerRadius: 8)
                  .strokeBorder(Color.secondaryTextColor, lineWidth: 0.8)
            )
            .background(viewModel.didVerifyUsernameForPasswordReset ? .gray.opacity(0.4) : .clear, in: RoundedRectangle(cornerRadius: 8))
            .disabled(viewModel.didVerifyUsernameForPasswordReset)
            .onChange(of: viewModel.usernameText) { newValue in
               if newValue.isEmpty {
                  viewModel.subtitleText = "Enter your email to get started"
                  viewModel.didVerifyUsernameForPasswordReset.toggle()
               }
            }
         
         HStack {
            if viewModel.isPasswordVisible {
               TextField("New Password", text: $viewModel.passwordText)
            } else {
               SecureField("New Password", text: $viewModel.passwordText)
            }
            
            Image(systemName: viewModel.isPasswordVisible ? "eye.slash" : "eye")
               .foregroundStyle(Color.secondaryTextColor)
               .onTapGesture { viewModel.isPasswordVisible.toggle() }
         }
         .padding()
         .background(viewModel.didVerifyUsernameForPasswordReset ? .clear : .gray.opacity(0.4), in: RoundedRectangle(cornerRadius: 8))
         .overlay (
            RoundedRectangle(cornerRadius: 8)
               .strokeBorder(Color.secondaryTextColor, lineWidth: 0.8)
         )
         .disabled(!viewModel.didVerifyUsernameForPasswordReset)
      }
      .textInputAutocapitalization(.never)
      .padding(.bottom)
   }
   
   var signInButton: some View {
      BaseButton(buttonText: viewModel.btnText, loadingState: viewModel.isLoading/*, validationsSatisfied: validateFields()*/) {
         if !viewModel.didVerifyUsernameForPasswordReset {
            viewModel.performforgotPassword(username: viewModel.usernameText)
         } else {
            viewModel.performResetPassword(password: viewModel.passwordText)
         }
      }
      .padding(.bottom, 30)
   }
   
   func validateFields() -> Bool {
      viewModel.usernameText.isNotEmpty
   }
   
}

#Preview {
    ForgotPasswordView()
}
