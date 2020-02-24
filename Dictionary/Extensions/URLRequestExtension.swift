//
//  URLRequestExtension.swift
//  Dictionary
//
//  Created by Samet Berberoglu on 24.02.2020.
//  Copyright © 2020 ridvanmertoglu. All rights reserved.
//

import Foundation

private let baseUrl = "https://wordsapiv1.p.rapidapi.com/"
private let header = ["x-rapidapi-host": "wordsapiv1.p.rapidapi.com",
                      "x-rapidapi-key": "bebb0977a7msh7e8c3ff56cf1a9dp16de43jsn2f87071534b1"]

extension URLRequest {
    init(path: String) {
        let url = URL(string: "\(baseUrl)\(path)")
        self = URLRequest(url: url!,
                          cachePolicy: .useProtocolCachePolicy,
                          timeoutInterval: 10.0)
        httpMethod = "GET"
        allHTTPHeaderFields = header
    }
}
