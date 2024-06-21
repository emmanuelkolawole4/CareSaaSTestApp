//
//  BaseButton.swift
//  CareSaaSTestApp
//
//  Created by MacBook on 6/16/24.
//

import SwiftUI

struct BaseButton: View {
   
   let buttonText: String
   var loadingState: Bool
   var condition: Bool? = false
   var validationsSatisfied: Bool = true
   let action: () -> Void
   
   var body: some View {
      HStack {
         Button {
            action()
         } label: {
            ZStack(alignment: .center) {
               if !loadingState {
                  Text(buttonText)
                     .font(.system(size: 16, weight: .semibold))
                     .foregroundStyle(.white)
               } else {
                  ProgressView()
                     .frame(width: 50, height: 25)
               }
            }
            .padding(.vertical, 20)
            .frame(maxWidth: .infinity)
//            .background(condition ?? false ? Color.primaryButtonColor : Color.accentColor)
            .background(validationsSatisfied ? Color.accentColor : Color.primaryButtonColor)
            .cornerRadius(10)
            
         }
         .disableWithOpacity(validationsSatisfied ? false : true)
      }
   }
}

#Preview {
   BaseButton(buttonText: "Sign In", loadingState: false, validationsSatisfied: true) {
      print("did tap button")
   }
}
