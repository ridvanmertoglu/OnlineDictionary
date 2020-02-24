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
    
    private lazy var viewModel = WordViewModel()
    
    var chosenDefinition = ""
    var chosenPartOfSpeech = ""
    var chosenSynonyms = ""
    var chosenExamples = ""
    var selectedWord: String?
    var selectedWordId : UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        viewModel.addChangeHandler { [weak self] (state) -> Void in
            DispatchQueue.main.async {
                switch state {
                case .fetching:
                    // Show activity indicator
                    print("fetching")
                case .failed(let message):
                    // close activity indicator and print out the error
                    print(message!)
                case .succeeded:
                    // close activity indicator
                    self?.saveWord()
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let selected = selectedWord {
            textField.text = selected
            clickedSearchButton()
        }
    }
    
    @IBAction private func clickedSearchButton() {
        guard let text = textField.text else { return }
        viewModel.fetchWordResults(givenWord: text)
    }
    
    //core dataya kelimeleri kaydetmek için bu fonksiyonu yazdım.
    func saveWord() {
        DispatchQueue.main.async {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let newWord = NSEntityDescription.insertNewObject(forEntityName: "Words", into: context)//NSManagedObject istiyor default olarak unwrap force u ortadan kaldırınca o yüzden kaldıramadım ! i as! deki
            
            newWord.setValue(self.textField.text, forKey: "wordName")
            newWord.setValue(UUID(), forKey: "id")
            
            do {
                try context.save()
                print("success")
            } catch {
                print("error")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text =  viewModel.word?.results?[indexPath.row].definition
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.word?.results?.count ?? 0
    }
    
    //force unwrapleri yok etmek için bu şekilde yaptım fakat ne kadar doğru emin olamadım
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let result = viewModel.word?.results?[indexPath.row]
        chosenDefinition = result?.definition ?? ""
        chosenPartOfSpeech = result?.partOfSpeech ?? ""
        chosenSynonyms = stringConcatinate(inputArray: result?.synonyms ?? [""])
        chosenExamples = stringConcatinate(inputArray: result?.examples ?? [""])
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
