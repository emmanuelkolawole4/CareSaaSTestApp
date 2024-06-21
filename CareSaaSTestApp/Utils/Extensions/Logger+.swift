//
//  Logger+.swift
//  CareSaaSTestApp
//
//  Created by MacBook on 6/16/24.
//

import Foundation
import OSLog
import os.log

@available(iOS 14.0, *)
let logger = Logger(subsystem: Bundle.main.appBundleID, category: "CareSaaS")

func kprint(_ msg: String, logType: OSLogType = .debug) {
#if DEBUG
   switch logType {
   case .debug, .default:
      if #available(iOS 14.0, *) {
         logger.debug("\(msg)")
      } else {
         os_log(.debug, "[DEBUG]: %s", msg)
      }
   case .info:
      if #available(iOS 14.0, *) {
         logger.info("\(msg)")
      } else {
         os_log(.info, "[INFO]: %s", msg)
      }
   case .fault:
      if #available(iOS 14.0, *) {
         logger.fault("\(msg)")
      } else {
         os_log(.fault, "[FAULT]: %s", msg)
      }
   case .error:
      if #available(iOS 14.0, *) {
         logger.error("\(msg)")
      } else {
         os_log(.error, "[ERROR]: %s", msg)
      }
   default:
      debugPrint(msg)
   }
#endif
}

