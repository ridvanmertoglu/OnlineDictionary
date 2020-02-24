//
//  WordViewModal.swift
//  Dictionary
//
//  Created by Samet Berberoglu on 23.02.2020.
//  Copyright © 2020 ridvanmertoglu. All rights reserved.
//

import Foundation

struct WordViewModelState {
    enum Change: StateChange {
        case fetching
        case succeeded
        case failed(message: String?)
    }
}

final class WordViewModel: StatefulViewModel<WordViewModelState.Change> {
    
    var word: Word?
    
    func fetchWordResults(givenWord:String) {
        let path = "words/\(givenWord)"
        let request = URLRequest(path: path)
        emit(change: .fetching)
        NetworkManager.shared.fetchResponse(request: request) { [weak self] (data, error) in
            if let err = error {
                self?.emit(change: .failed(message: err.localizedDescription))
                return
            }
            guard let data = data else {
                self?.emit(change: .failed(message: "Data Boş"))
                return
            }
            
            self?.word = Word.decodeObject(data: data)
            self?.emit(change: .succeeded)
        }
    }
    
}
