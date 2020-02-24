//
//  NetworkManager.swift
//  Dictionary
//
//  Created by RIDVAN on 12.02.2020.
//  Copyright © 2020 ridvanmertoglu. All rights reserved.
//

import UIKit

typealias ServiceResponseBlock = (Data?, Error?) -> Void

final class NetworkManager {

    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchResponse(request: URLRequest, completion: ServiceResponseBlock?) {
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let err = error,
                data != nil {
                completion?(nil, err)
                return
            }
            completion?(data, nil)
        }.resume()
    }
}
