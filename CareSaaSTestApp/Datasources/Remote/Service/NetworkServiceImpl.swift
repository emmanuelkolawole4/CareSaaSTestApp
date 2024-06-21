//
//  NetworkServiceImpl.swift
//  CareSaaSTestApp
//
//  Created by MacBook on 6/16/24.
//

import Foundation
import Network

final class NetworkServiceImpl: INetworkService {
   
   private let monitor = NWPathMonitor()
   private let urlSession: URLSession
   
   init(urlSession: URLSession = URLSession.shared) {
      self.urlSession = urlSession
      startMonitoring()
   }
   
   private func startMonitoring() {
      monitor.pathUpdateHandler = { path in
         if path.status == .satisfied {
            print("Network is available")
         } else {
            print("No network connection")
         }
      }
      
      let queue = DispatchQueue(label: "NetworkMonitor")
      monitor.start(queue: queue)
   }
   
   func makeRequest<T: Codable>(
      endpoint: Endpoint,
      method: HTTPMethod,
      parameters: Parameters?,
      headers: [String : String]?,
      responseType: T.Type
   ) async throws -> T {
      guard monitor.currentPath.status == .satisfied else {
         throw NetworkError.noInternetConnection
      }
      
      guard var urlComponents = URLComponents(string: endpoint.path) else {
         throw NetworkError.invalidURL
      }
      
      if let parameters, method == .get {
         urlComponents.queryItems = parameters.map { key, value in
            URLQueryItem(name: key, value: String(describing: value))
         }
      }
      
      guard let requestURL = urlComponents.url else {
         throw NetworkError.invalidURL
      }
      
      kprint("Request URL: \(requestURL.absoluteURL)")
      
      var urlRequest = URLRequest(url: requestURL)
      urlRequest.httpMethod = method.rawValue
      
      kprint("HTTP Method: \(method.rawValue)")
      
      if let parameters, method == .post, let requestBody = parameters.data {
         urlRequest.httpBody = requestBody
         kprint("Request params: \(parameters.prettyJson)")
         kprint("Request body: \(try requestBody.prettyJson())")
      }
      
      if let headers {
         for (key, value) in headers {
            urlRequest.setValue(value, forHTTPHeaderField: key)
         }
         kprint("Request headers: \(headers.prettyJson)")
      }
      
      let (data, response) = try await urlSession.data(for: urlRequest)
      
      guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
         throw handleAppError(data: data, response: response)
      }
      
      let kdata = data
      
      do {
         kprint("Data => PrettyJson")
         kprint(try kdata.prettyJson())
      } catch {
         kprint("Data => PrettyJson Failure")
         kprint("\(error)")
      }
      
      do {
         let response = try kdata.decode(into: T.self)
         
         kprint("Request Response:")
         kprint(response.prettyJson)
         
         return response
      } catch {
         kprint("Decoding Error:")
         kprint("\(error.localizedDescription)", logType: .fault)
         
         throw NetworkError.decodingFailed
      }
   }
   
   private func handleAppError(data: Data, response: URLResponse) -> NetworkError {
      if let serverError = try? data.decode(into: ServerResponse.self) {
         return .serverError(code: serverError.code.orZero, message: serverError.message ?? "Unknwon server error")
      }
      
      if let constraintError = try? data.decode(into: ErrorResponse.self) {
         return .serverError(code: -1, message: constraintError.first?.message ?? "Unknown constraint error")
      }
      
      let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
      return .serverError(code: statusCode, message: "Failed to decode error message from server")
   }
   
}
