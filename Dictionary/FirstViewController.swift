//
//  FirstViewController.swift
//  Dictionary
//
//  Created by RIDVAN on 6.02.2020.
//  Copyright © 2020 ridvanmertoglu. All rights reserved.
//

import UIKit
import Foundation

class FirstViewController: UIViewController {

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

        let request = NSMutableURLRequest(url: NSURL(string: "https://wordsapiv1.p.rapidapi.com/words/\(textField.text!)/definitions")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error ?? "Error")
            } else {
                /*let httpResponse = response as? HTTPURLResponse
                print(httpResponse)*/
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, Any>
                    
                    DispatchQueue.main.async {
                        print(jsonResponse["definitions"])
                        /*if let def = jsonResponse["definitions"] as? Array<Any> {
                            for element in def {
                                print(element)
                            }
                        }*/
                    }
                    
                } catch {
                    print("olmadı")
                }
            }
        })

        dataTask.resume()
        
    }
    
}

