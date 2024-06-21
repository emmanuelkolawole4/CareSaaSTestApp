//
//  Bundle+.swift
//  CareSaaSTestApp
//
//  Created by MacBook on 6/16/24.
//

import Foundation

extension Bundle {
   
   func value<T>(for key: String) -> T? {
      object(forInfoDictionaryKey: key) as? T
   }
   
   var baseURL: String { value(for: "BASE_URL")! }
   
   var appBundleID: String { value(for: "BUNDLE_ID")! }
}
