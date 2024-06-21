//
//  UIApplication+.swift
//  CareSaaSTestApp
//
//  Created by MacBook on 6/17/24.
//

import Foundation
import UIKit

extension UIApplication {
   
   func endEditiong() {
      sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
   }
   
}
