//
//  Response.swift
//  GlovoChallenge
//
//  Created by Ibrahim Kteish on 7/23/18.
//  Copyright © 2018 Ibrahim Kteish. All rights reserved.
//

import Foundation
import RxSwift

public struct DataTaskCompletion {
  
  let data: Data?
  let error: Error?
  let response: HTTPURLResponse?
}

public enum Response {
  /// Enums holds the different network error types that might occure
  public enum NetworkError: Error {
    case error(Error)
    case notFound
    case unpackingJSON
    case unpackingData
    case serverNotReachable
    case noData
    case badInput
    case unknown
    case serverError(Int)
    case clientError(Int)
    case requestError(String?, Int?)
    case mismatchData
    case connectionLost
    case notConnectedToInternet
    case internationalRoamingOff
    
    public init(error: Error) {
      if let error = error as? NetworkError {
        self = error
      } else if let error = error as? URLError {
        switch error.code {
        case .timedOut, .cannotFindHost, .cannotConnectToHost:
          self = .serverNotReachable
        case .networkConnectionLost:
          self = .connectionLost
        case .dnsLookupFailed:
          self = .serverNotReachable
        case .notConnectedToInternet:
          self = .notConnectedToInternet
        case .internationalRoamingOff:
          self = .internationalRoamingOff
        default:
          self = .error(error)
        }
      } else {
        self = .error(error)
      }
    }
  }
  
  case json(_: [String: Any])
  case data(_: Data)
  case string(_: String)
  case empty
  case error(NetworkError)
  
  init(_ completion: DataTaskCompletion, for request: Request) { // swiftlint:disable:this cyclomatic_complexity
    if let e = completion.error {
      self = .error(NetworkError.init(error: e))
      return
    }
    
    guard let statusCode = completion.response?.statusCode else {
      self = .error(NetworkError.unknown)
      return
    }
    
    switch statusCode {
      
    case 200:
      // If we don't get data back, alert the user.
      guard let data = completion.data else {
        self = .error(NetworkError.noData)
        return
      }
      
      do {
        
        switch request.dataType {
        case .data:
          self = .data(data)
        case .json:
          // If we get data but can't unpack it as JSON, alert the user.
          let jsonDictionary = try JSONSerialization.jsonObject(with: data, options: []) as! [String: AnyObject] // swiftlint:disable:this force_cast
          //at this point we had a proper JSON and jsonDictionary is holding its value.
          self = .json(jsonDictionary)
        case .string:
          if let string = String(data: data, encoding: .utf8) {
            self = .string(string)
          } else {
            self = .error(Response.NetworkError.unpackingData)
          }
        }
      } catch {
        self = .error(NetworkError.unpackingJSON)
      }
    case 404:       self = .error(NetworkError.notFound)
    case 400...499: self = .error(NetworkError.clientError(statusCode))
    case 500...599: self = .error(NetworkError.serverError(statusCode))
    default:
      self = .error(NetworkError.unknown)
    }
  }
}
