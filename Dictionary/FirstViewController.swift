//
//  FirstViewController.swift
//  Dictionary
//
//  Created by RIDVAN on 6.02.2020.
//  Copyright © 2020 ridvanmertoglu. All rights reserved.
//

import UIKit
import Foundation

class FirstViewController: BaseVC {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var definitionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func clickedSearchButton(_ sender: Any) {
    
        let headers = [
            "x-rapidapi-host": "wordsapiv1.p.rapidapi.com",
            "x-rapidapi-key": "bebb0977a7msh7e8c3ff56cf1a9dp16de43jsn2f87071534b1"
        ]
        
        guard let url = URL(string: "https://wordsapiv1.p.rapidapi.com/words/\(textField.text!)") else { return }

        var request = URLRequest(url: url,
                                 cachePolicy: .useProtocolCachePolicy,
                                 timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let dataTask = URLSession.shared.dataTask(with: request as URLRequest,
                                                  completionHandler: { (data, response, error) -> Void in
                                                    
            if let data = data {
                do {
                    let word = try JSONDecoder().decode(Word.self, from: data)
                    print("")
                } catch (let error) {
                    print(error.localizedDescription)
                }
            }
        })

        dataTask.resume()
        
    }
    
}

extension Data {
    var prettyPrintedJSONString: String? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
            let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
            let prettyPrintedString = String(data: data, encoding: .utf8) else { return nil }
        return prettyPrintedString
    }
}
