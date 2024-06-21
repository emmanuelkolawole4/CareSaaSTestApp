//
//  Code+.swift
//  CareSaaSTestApp
//
//  Created by MacBook on 6/16/24.
//

import Foundation
import UIKit

typealias VoidAction = (() -> Void)
typealias Parameters = [String: Any]
typealias ArgumentAction<T> = ((T) -> Void)
typealias ErrorResponse = [ErrorResponseElement]

extension Collection {
   
   var isNotEmpty: Bool { !isEmpty }
   
}

public extension Collection {
   
   func chunk(n: Int) -> [SubSequence] {
      var res: [SubSequence] = []
      var i = startIndex
      var j: Index
      while i != endIndex {
         j = index(i, offsetBy: n, limitedBy: endIndex) ?? endIndex
         res.append(self[i..<j])
         i = j
      }
      return res
   }
   
}

public extension String {
   
   var isValidEmail: Bool {
           let emailRegEx = "(?:[a-zA-Z0-9!#$%\\&'*+/=?^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%\\&'*+/=?^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?\\.)+[a-zA-Z]{2,}"
           let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
           return emailPredicate.evaluate(with: self)
       }
   
   var isNumber: Bool {
      rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
   }
   
   var isNotNumber: Bool { !isNumber }
   
   func chunkFormatted(withChunkSize chunkSize: Int = 4, withSeparator separator: Character = " ") -> String {
      return self.filter { $0 != separator }.chunk(n: chunkSize).map{ String($0) }.joined(separator: String(separator))
   }
   
   func formatWith234() -> String {
      var value = self
      value.replaceSubrange(value.startIndex...value.startIndex, with: "+234")
      return value
   }
   
   var remove234: String {
      return self.replacingOccurrences(of: "+234", with: "0")
   }
   
   var orDash: String {
      return self.isEmpty ? "-" : self
   }
   
   var orEmpty: String {
      return self.isEmpty ? "" : self
   }
   
   func copyToClipboard() {
      UIPasteboard.general.string = self
   }
   
   var int: Int? { Int(self) }
   
   var float: Float? { Float(self) }
   
   var double: Double? { Double(self) }
   
   var dropFirstIfZero: String {
      if first == "0" {
         return String(dropFirst())
      }
      return self
   }
   
   var jsonBundleURL: URL? { Bundle.main.url(forResource: self, withExtension: "json") }
   
   func insensitiveEquals(_ value: String) -> Bool {
      localizedCaseInsensitiveCompare(value) == .orderedSame
   }
   
   func insensitiveNotEquals(_ value: String) -> Bool {
      localizedCaseInsensitiveCompare(value) != .orderedSame
   }
   
   func insensitiveContains(_ value: String) -> Bool {
      lowercased().localizedCaseInsensitiveContains(value.lowercased())
   }
   
   func dateFormatted(
      from fromFormat: String = "yyyy-MM-dd'T'HH:mm:ss'Z'",
      using toFormat: String = "dd/mm/yyyy"
   ) -> String {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = fromFormat
      
      if let date = dateFormatter.date(from: self) {
         dateFormatter.dateFormat = toFormat
         return dateFormatter.string(from: date)
      } else {
         return "--"
      }
   }
   
   var whitespacesAndBNewlinesRemoved: String { trimmingCharacters(in: .whitespacesAndNewlines) }
   
   var digitsRemoved: String { components(separatedBy: .decimalDigits).joined() }
   
   var whitespacesAndNewlinesRemoved: String { trimmingCharacters(in: .whitespacesAndNewlines).spacesRemoved }
   
   var spacesRemoved: String { replacingOccurrences(of: " ", with: "") }
   
   var dashesRemoved: String { replacingOccurrences(of: "-", with: "") }
   
   var commasRemoved: String { replacingOccurrences(of: ",", with: "") }
   
   func insensitiveContains(_ strings: [String]) -> Bool {
      strings.contains { insensitiveContains($0) }
   }
   
   func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
      let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
      let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
      return boundingBox.height
   }
   
   var height: CGFloat {
      let maxSize = CGSize(width: UIScreen.main.bounds.width, height: .greatestFiniteMagnitude)
      let size = NSAttributedString(string: self).boundingRect(with: maxSize, options: [.usesFontLeading, .usesLineFragmentOrigin], context: nil)
      return ceil(size.height)
   }
   
   var accessibilityIdentifier: String {
      lowercased().replacingOccurrences(of: " ", with: "_")
   }
   
   var reversedAccessibilityIdentifier: String {
      lowercased().replacingOccurrences(of: "_", with: " ")
   }
   
}

extension Array where Element: Equatable {
   
   mutating func appendIfNotExists<S: Sequence>(contentsOf newElements: S) where S.Element == Element {
      for element in newElements {
         if !contains(element) {
            append(element)
         }
      }
   }
   
   mutating func remove(_ item: Element) {
      self = self.filter { $0 != item }
   }
   
}

extension Array {
   
   func getFirst(_ n: Int) -> [Element] {
      guard n >= 0 && n <= count else {
         print("Invalid value for 'firstN'")
         return self
      }
      
      return Array(prefix(Swift.min(n, count)))
   }
   
}

public extension Optional {
   
   var isNil : Bool { self == nil }
   
   var isNotNil : Bool { self != nil }
   
}

extension Optional where Wrapped == [Array<Any>] {
   
   var orEmptyList: [Any] { isNil ? [] : self! }
   
}

extension Optional where Wrapped == Int {
   
   var orZero: Int { isNil ? 0 : self! }
   
   var described: String { String(describing: self) }
   
}

extension Optional where Wrapped == String {
   var orEmpty: String {
      self ?? ""
   }
}

public extension Decodable {
   ///Maps JSON String to actual Decodable Object
   ///throws an exception if mapping fails
   static func mapFrom(jsonString: String) throws -> Self? {
      
      let decoder = JSONDecoder()
      //decoder.keyDecodingStrategy = .convertFromSnakeCase
      return try decoder.decode(Self.self, from: Data(jsonString.utf8))
   }
}

public extension Encodable {
   
   var jsonString: String {
      do {
         return String(data: try JSONEncoder().encode(self), encoding: .utf8) ?? ""
      } catch {
         return ""
      }
   }
   
   var prettyPrinted: String {
      let responseData = try! JSONSerialization.data(withJSONObject: self.dictionary, options: .prettyPrinted)
      return String(data: responseData, encoding: .utf8)!
   }
   
   var dictionaryValue: Any {
      do {
         let data = try JSONEncoder().encode(self)
         //return String(data: data , encoding: .utf8) ?? ""
         return try JSONSerialization.jsonObject(with: data)
      } catch {
         return ""
      }
   }
   
   var dictionaryArray: [[String: Any]] {
      return (try? JSONSerialization.jsonObject(with: JSONEncoder().encode(self))) as? [[String: Any]] ?? [[:]]
   }
   
}

extension Dictionary {
   mutating func merge<K, V>(_ dict: [K: V]){
      for (k, v) in dict {
         self.updateValue(v as! Value, forKey: k as! Key)
      }
   }
   
   init(_ slice: Slice<Dictionary>) {
      self = [:]
      
      for (key, value) in slice {
         self[key] = value
      }
   }
   
   func containKey(_ key: Key) -> Bool {
      return index(forKey: key) == nil ? false : true
   }
   
}


func runAfter(_ delay: Double = 0.2, block: @escaping VoidAction) {
   DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
      block()
   }
}

func runOnMainThread(action: @escaping () -> Void) {
   DispatchQueue.main.async {
      action()
   }
}

func runOnBackground(
   qos: DispatchQoS.QoSClass = .userInitiated,
   action: @escaping () -> Void
) {
   DispatchQueue.global(qos: qos).async {
      action()
   }
}

func formattedTime(from timeString: String) -> String {
   let inputFormatter = DateFormatter()
   inputFormatter.dateFormat = "HH:mm"
   
   let outputFormatter = DateFormatter()
   outputFormatter.dateFormat = "h:mm a"
   
   if let date = inputFormatter.date(from: timeString) {
      return outputFormatter.string(from: date)
   } else {
      return timeString // or handle the error as needed
   }
}
