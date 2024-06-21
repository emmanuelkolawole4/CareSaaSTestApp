//
//  AnyCodable.swift
//  CareSaaSTestApp
//
//  Created by MacBook on 6/18/24.
//

import Foundation

struct AnyCodable: Codable, Identifiable {
   let value: Any
   let id = UUID().uuidString
   
   init(_ value: Any) {
      self.value = value
   }
   
   init(from decoder: Decoder) throws {
      let container = try decoder.singleValueContainer()
      
      if let value = try? container.decode(Bool.self) {
         self.value = value
      } else if let value = try? container.decode(Int.self) {
         self.value = value
      } else if let value = try? container.decode(Double.self) {
         self.value = value
      } else if let value = try? container.decode(String.self) {
         self.value = value
      } else if let value = try? container.decode([AnyCodable].self) {
         self.value = value.map { $0.value }
      } else if let value = try? container.decode([String: AnyCodable].self) {
         self.value = value.mapValues { $0.value }
      } else {
         throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode AnyCodable")
      }
   }
   
   func encode(to encoder: Encoder) throws {
      var container = encoder.singleValueContainer()
      
      if let value = value as? Bool {
         try container.encode(value)
      } else if let value = value as? Int {
         try container.encode(value)
      } else if let value = value as? Double {
         try container.encode(value)
      } else if let value = value as? String {
         try container.encode(value)
      } else if let value = value as? [AnyCodable] {
         try container.encode(value)
      } else if let value = value as? [String: AnyCodable] {
         try container.encode(value)
      } else {
         throw EncodingError.invalidValue(value, EncodingError.Context(codingPath: container.codingPath, debugDescription: "Cannot encode AnyCodable"))
      }
   }
}
