//
//  APIManager.swift
//  Twitch
//
//  Created by Lubov on 23.05.2021.
//

import Foundation

typealias JSONTask = URLSessionDataTask
typealias JSONCompletionHandler = (Data?, HTTPURLResponse?, Error?) -> Void

public let twtNetworkingErrorDomain = "com.lubov.Twitch.NetworkingError"
public let missingHTTPREsponseError = 100
public let unexpectedResponseError = 200


enum APIResult<T> {
    case Success(T)
    case Failure(Error)
}

protocol APIManager {
    
    var sessionConfiguration : URLSessionConfiguration { get }
    var session : URLSession { get }
    
    func JSONTaskWith(request: URLRequest, completion: @escaping JSONCompletionHandler) -> JSONTask
    func fetch<T>(request: URLRequest, decode: @escaping (Data) -> T?, completion: @escaping (APIResult<T>) -> Void)
}

extension APIManager {
    
    func JSONTaskWith(request: URLRequest, completion: @escaping JSONCompletionHandler) -> JSONTask {
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            
            guard let HTTPResponse = response as? HTTPURLResponse else {
                let userInfo = [
                    NSLocalizedDescriptionKey : NSLocalizedString("Missing HTTP Response", comment: "")
                ]
                let error = NSError(domain: twtNetworkingErrorDomain, code: 100, userInfo: userInfo)
                completion(nil, nil, error)
                return
            }
            if data == nil {
                if let error = error {
                    completion(nil, HTTPResponse, error)
                }
            } else {
                switch HTTPResponse.statusCode{
                case 200:
                    completion(data, HTTPResponse, nil)
                default:
                    print("Response Status: \(HTTPResponse.statusCode)")
                }
            }
        }
        return dataTask
    }
    
    func fetch<T>(request: URLRequest, decode: @escaping (Data) -> T?, completion: @escaping (APIResult<T>) -> Void) {
        
        let dataTask = JSONTaskWith(request: request) { (data, response, error) in
            
            guard let data = data else {
                if let error = error{
                    completion(.Failure(error))
                }
                return
            }
            if let value = decode(data) {
                completion(.Success(value))
            } else {
                let error = NSError(domain: twtNetworkingErrorDomain, code: 200, userInfo: nil)
                completion(.Failure(error))
            }
        }
        dataTask.resume()
    }
}
