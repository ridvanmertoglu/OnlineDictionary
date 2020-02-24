//
//  DecodableExtension.swift
//  Dictionary
//
//  Created by Samet Berberoglu on 24.02.2020.
//  Copyright © 2020 ridvanmertoglu. All rights reserved.
//

import Foundation

extension Decodable {
    static func decodeObject<T: Decodable>(data: Data?) -> T? {
        guard let data = data else { return nil }
        let object = try? JSONDecoder().decode(T.self, from: data)
        return object
    }
}
