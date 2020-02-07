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
    var definitions: [Definition]?
}

final class Definition: Decodable {
    var definition: String?
    var partOfSpeech: String?
}
