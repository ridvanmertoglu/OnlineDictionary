//
//  FirstViewController.swift
//  Dictionary
//
//  Created by RIDVAN on 6.02.2020.
//  Copyright © 2020 ridvanmertoglu. All rights reserved.
//

import UIKit
import CoreData

class FirstViewController: BaseVC, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet private weak var tableView: UITableView!
    
    var numberofRow = 0
    var resultArray = [Result]()
    var chosenDefinition = ""
    var chosenPartOfSpeech = ""
    var chosenSynonyms = ""
    var chosenExamples = ""
    var selectedWord = ""
    var selectedWordId : UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func clickedSearchButton(_ sender: Any) {
        fetchWordResults(givenWord: textField.text!)
        
        //bu ikisinin burda olup olmayacagından emin değilim
        // bu ikisini viewDidLoad da yapınca hata verdi bende orda yapıyordum ama
        tableView.delegate = self
        tableView.dataSource = self

        saveWord()
    }
    
  
    
    
    /*bu fonksiyonun bir kısmını networkmanager a alacaktım
    fakat ayırınca hatalar cıktı tam olarak nerden bölünmesine karar veremedim.*/
    func fetchWordResults(givenWord:String) {
        guard let url = URL(string: "\(Constant.baseUrl+Constant.wordPath)\(givenWord)") else { return }
        var request = URLRequest(url: url,
                                 cachePolicy: .useProtocolCachePolicy,
                                 timeoutInterval: 10.0)
        request.httpMethod = Constant.httpMethod
        request.allHTTPHeaderFields = Constant.headers

        let dataTask = URLSession.shared.dataTask(with: request as URLRequest,
                                                  completionHandler: { (data, response, error) -> Void in
                                                    
            if let data = data {
                do {
                    let word = try JSONDecoder().decode(Word.self, from: data)
                    if let resultsOfWord = word.results {
                        for def in resultsOfWord {
                            self.resultArray.append(def)
                        }
                        self.numberofRow = word.results?.count ?? 0
                    }
                    
                } catch (let error) {
                    print(error.localizedDescription)
                }
            }
        })
        
        dataTask.resume()
        print("girdi")
    }
    
    //core dataya kelimeleri kaydetmek için bu fonksiyonu yazdım.
    func saveWord() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newWord = NSEntityDescription.insertNewObject(forEntityName: "Words", into: context)//NSManagedObject istiyor default olarak unwrap force u ortadan kaldırınca o yüzden kaldıramadım ! i as! deki
        
        newWord.setValue(textField.text, forKey: "wordName")
        newWord.setValue(UUID(), forKey: "id")
        
        do {
            try context.save()
            print("success")
        } catch {
            print("error")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = resultArray[indexPath.row].definition
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberofRow
    }
    
    //force unwrapleri yok etmek için bu şekilde yaptım fakat ne kadar doğru emin olamadım
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenDefinition = resultArray[indexPath.row].definition ?? ""
        chosenPartOfSpeech = resultArray[indexPath.row].partOfSpeech ?? ""
        chosenSynonyms = stringConcatinate(inputArray: resultArray[indexPath.row].synonyms ?? [""])
        chosenExamples = stringConcatinate(inputArray: resultArray[indexPath.row].examples ?? [""])
        performSegue(withIdentifier: "toDetailViewController", sender: nil)
    }
    
    //Kelimelerin synonmym lerini ve example sentence ları birleştirmek için bu fonksiyonu yazdım.
    func stringConcatinate(inputArray:Array<String>) -> String {
        var concatinatedString = ""
        for element in inputArray {
            concatinatedString += element
            concatinatedString += "\n"
        }
        return concatinatedString
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailViewController" {
            let destinationVC = segue.destination as? DetailViewController
            destinationVC?.selectedDefinition = chosenDefinition
            destinationVC?.selectedPartofSpeech = chosenPartOfSpeech
            destinationVC?.selectedSynonyms = chosenSynonyms
            destinationVC?.selectedExamples = chosenExamples
        }
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
