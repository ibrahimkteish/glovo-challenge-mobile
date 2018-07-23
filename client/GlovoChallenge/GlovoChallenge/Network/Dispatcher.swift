//
//  Dispatcher.swift
//  GlovoChallenge
//
//  Created by Ibrahim Kteish on 7/23/18.
//  Copyright © 2018 Ibrahim Kteish. All rights reserved.
//
import  Foundation
import RxSwift

/// The dispatcher is responsible to execute a Request
/// by calling the underlyning layer (maybe URLSession, Alamofire
/// or just a fake dispatcher which return mocked results).
/// As output for a Request it should provide a Response.
public protocol Dispatcher {
  
  /// Configure the dispatcher with an environment
  ///
  /// - Parameter environment: environment configuration
  init(environment: Environment)
  
  /// This function execute the request and provide a callback
  /// with the response.
  ///
  /// - Parameter:
  ///     - request: request to execute
  ///     - completionHandler: a completion handler check TrellisAPICompletionHandler
  /// - Returns: Observable
  func execute(request: Request) -> Observable<Response>
  
}

/// The dispatcher is responsible to execute a Request
/// by calling the underlyning layer (maybe URLSession, Alamofire
/// or just a fake dispatcher which return mocked results).
/// As output for a Request it should provide a Response.
public final class NetworkDispatcher: Dispatcher {
  
  // MARK: Properties
  static let kErrorCode = "errorCode"
  static let kErrorContainer = "errorContainer"
  
  private var environment: Environment
  
  // MARK: init
  required public init(environment: Environment) {
    self.environment = environment
  }
  
  // MARK: Public
  /// This function execute the request and provide a callback
  /// with the response.
  ///
  /// - Parameter:
  ///     - request: request to execute
  ///     - completionHandler: a completion handler check TrellisAPICompletionHandler
  /// - Returns: Observable
  public func execute(request: Request) -> Observable<Response> {
    
    return Observable.create { [weak self] observer in
      do {
        let foundationRequest = try self?.prepareURLRequest(for: request)
        let task = self?.environment.session.dataTask(with: foundationRequest!, completionHandler: { (dataOptional, response, error) -> Void in
          
          let dataTaskCompletion = DataTaskCompletion(data: dataOptional, error: error, response: response as? HTTPURLResponse)
          guard dataTaskCompletion.error == nil else {
            observer.on(.error(dataTaskCompletion.error!))
            return
          }
          let response = Response(dataTaskCompletion, for: request)
          observer.onNext(response)
          observer.onCompleted()
        })
        task?.resume()
        return Disposables.create { task?.cancel() }
      } catch let error {
        observer.onError(error)
        return Disposables.create()
      }
    }
  }
  
  // MARK: Private Methods
  
  func encode(_ parameters: [String: String]) -> [String: String] {
    return Dictionary(uniqueKeysWithValues:
      parameters.map { key, value in (key, value.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "") })
  }
  
  /// prepare the request for excution.
  ///
  /// - Parameter request: network request
  /// - Throws: NetworkError enum case
  /// - Returns: an URLRequest
  private func prepareURLRequest(for request: Request) throws -> URLRequest { // swiftlint:disable:this function_body_length cyclomatic_complexity
    
    var fullURL = "\(environment.host)/\(request.path)"
    
    if environment.host.isEmpty {
      fullURL = request.path
    }
    // Compose the url
    guard let url = URL(string: fullURL) else {
      throw Response.NetworkError.badInput
    }
    var urlRequest = URLRequest(url: url)
    
    // Working with parameters
    switch request.parameters {
    case let .data(data):
      urlRequest.httpBody = data
    case .body(let params, let json):
      if json {
        // Parameters are part of the body
        if let params = params { // just to simplify
          let jsonData = try JSONSerialization.data(withJSONObject: params, options: .init(rawValue: 0))
          urlRequest.httpBody = jsonData
        } else {
          throw Response.NetworkError.badInput
        }
      } else {
        if let parameters = params as? [String: String], let body = self.encode(parameters).queryString.data(using: .utf8) {
          urlRequest.httpBody = body
        } else {
          throw Response.NetworkError.badInput
        }
        
      }
    case .url(let params):
      // Parameters are part of the url
      if let params = params as? [String: String] { // just to simplify
        let queryParams = params.map({ (element) -> URLQueryItem in
          return URLQueryItem(name: element.key, value: element.value)
        })
        guard var components = URLComponents(string: fullURL) else {
          throw Response.NetworkError.badInput
        }
        components.queryItems = queryParams
        urlRequest.url = components.url
      } else {
        throw Response.NetworkError.badInput
      }
    case .noParams:
      break
    }
    
    // Add headers from enviornment and request
    environment.headers.forEach { urlRequest.addValue($0.value as! String, forHTTPHeaderField: $0.key) } // swiftlint:disable:this force_cast
    request.headers?.forEach { urlRequest.addValue($0.value as! String, forHTTPHeaderField: $0.key) } // swiftlint:disable:this force_cast
    
    // Setup HTTP method
    urlRequest.httpMethod = request.method.rawValue
    
    print(urlRequest.description)
    return urlRequest
    
  }
}

extension Dictionary {
  ///Extract query string from dictionary. key=value&key2=value2
  var queryString: String {
    var output: String = ""
    for (key, value) in self {
      output +=  "\(key)=\(value)&"
    }
    output = String(output.dropLast())
    return output
  }
}


///struct for creating a suitable Network Dispatcher
public struct NetworkDispatcherFactory {
  
  /// Get a development dispatcher
  ///
  /// - Returns: Development dispatcher
  public static let development: NetworkDispatcher = {
    let dispatcher = NetworkDispatcher(environment: EnvironmentFactory.developmentEnv)
    return dispatcher
  }()
  
  /// Get a development dispatcher
  ///
  /// - Returns: noHost dispatcher
  public static let noHost: NetworkDispatcher = {
    let dispatcher = NetworkDispatcher(environment: EnvironmentFactory.noHost)
    return dispatcher
  }()
}
