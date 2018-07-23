//
//  Session.swift
//  GlovoChallenge
//
//  Created by Ibrahim Kteish on 7/23/18.
//  Copyright © 2018 Ibrahim Kteish. All rights reserved.
//

import Foundation

protocol SessionConfigurationProtocol {
  
  var requestTimeout: Double { get }
  var resourceTimeout: Double { get }
  var httpMaximumConnectionsPerHost: Int { get }
  var sessionConfiguration: URLSessionConfiguration { get }
  init()
}

final class SessionConfiguration: SessionConfigurationProtocol {
  
  internal let requestTimeout: Double  = 30.0
  internal let resourceTimeout: Double = 60.0 * 2.0
  internal let httpMaximumConnectionsPerHost: Int = 2
  
  var sessionConfiguration: URLSessionConfiguration = URLSessionConfiguration.default
  
  lazy private var cache: URLCache = {
    
    let memoryCacheLimit: Int = 10 * 1024 * 1024
    let diskCapacity: Int = 50 * 1024 * 1024
    
    /**
     * http://nsscreencast.com/episodes/91-afnetworking-2-0
     */
    
    let cache: URLCache = URLCache(memoryCapacity: memoryCacheLimit, diskCapacity: diskCapacity, diskPath: nil)
    return cache
  }()
  
  init() {
    
    let additionalHeaders: [String: String] = ["Accept": "application/json", "Content-Type": "application/json; charset=UTF-8", "User-Agent": "(iPhone;)"]
    
    self.sessionConfiguration.requestCachePolicy         = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
    self.sessionConfiguration.timeoutIntervalForRequest  = self.requestTimeout
    self.sessionConfiguration.timeoutIntervalForResource = self.resourceTimeout
    self.sessionConfiguration.httpAdditionalHeaders      = additionalHeaders
    self.sessionConfiguration.httpMaximumConnectionsPerHost = self.httpMaximumConnectionsPerHost
    self.sessionConfiguration.urlCache                   = self.cache
  }
}

protocol NetworkSessionProtocol {
  var session: URLSession { get }
}

public final class NetworkSession: NetworkSessionProtocol {
  
  // MARK: Private methods
  
  private let sessionDescription = "com.glovo.challenge.network.session"
  
  // MARK: Public properties
  let session: URLSession
  let configuration: SessionConfigurationProtocol
  
  static let shared = NetworkSession(configuration: SessionConfiguration())
  
  // MARK: Constructors
  
  /// Designated initializer
  ///
  /// The session delegate is set to nil and will use the "system" provided
  /// delegate
  ///
  /// - returns: Session
  private init(configuration: SessionConfigurationProtocol) {
    self.configuration = configuration
    self.session = URLSession(configuration: configuration.sessionConfiguration, delegate: nil, delegateQueue: OperationQueue.main)
    self.session.sessionDescription = sessionDescription
  }
}
