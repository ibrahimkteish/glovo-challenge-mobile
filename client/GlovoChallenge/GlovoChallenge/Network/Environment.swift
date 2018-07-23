//
//  Environment.swift
//  GlovoChallenge
//
//  Created by Ibrahim Kteish on 7/23/18.
//  Copyright © 2018 Ibrahim Kteish. All rights reserved.
//

import Foundation

///Working Environment Type Production or Dev
public enum EnvironmentType {
  case prod
  case dev
}

//conformance to CustomDebugStringConvertible
extension EnvironmentType: CustomDebugStringConvertible {
  
  public var debugDescription: String {
    return self == .prod ? "Production" : "Development"
  }
}

/// Environment is a struct which encapsulate all the informations
/// we need to perform a setup of our Networking Layer.
/// we just define the type of the environment (ie. Production,
/// Test Environment #1 and so on) and the base url to complete requests.
/// We may also want to include any SSL certificate or wethever you need.
public struct Environment {
  
  var session: URLSession = {
    return NetworkSession.shared.session
  }()
  
  /// type of the environment
  var type: EnvironmentType
  
  /// Base URL of the environment
  var host: String
  
  /// This is the list of common headers which will be part of each Request
  /// Some headers value maybe overwritten by Request's own headers
  var headers: [String: Any] = [:]
  
  /// Initialize a new Environment
  ///
  /// - Parameters:
  ///   - type: type of the environment
  ///   - host: base url
  public init(_ type: EnvironmentType, host: String) {
    self.type = type
    self.host = host
  }
}

///A helper struct to facilitate dev/prod env setup
public struct EnvironmentFactory {
  
  /// Get a development environment
  ///
  /// - Returns: Development environment
  static let developmentEnv: Environment = {
    let env = Environment(.dev, host: "http://localhost:3000/api")
    return env
  }()
  
  /// Get a development environment
  ///
  /// - Returns: Development environment
  static let noHost: Environment = {
    let env = Environment(.dev, host: "")
    return env
  }()
}
