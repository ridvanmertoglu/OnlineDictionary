//
//  Word.swift
//  Dictionary
//
//  Created by Samet Berberoglu on 7.02.2020.
//  Copyright © 2020 ridvanmertoglu. All rights reserved.
//

import Foundation

final class Word: Decodable {
    var word: String?
    var results: [Result]?
}


final class Result: Decodable {
    var definition: String?
    var partOfSpeech: String?
    var synonyms: [String]?
    var typeOf: [String]?
    var hasTypes: [String]?
    var derivation: [String]?
    var examples: [String]?
}
