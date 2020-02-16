//
//  SecondViewController.swift
//  Dictionary
//
//  Created by RIDVAN on 6.02.2020.
//  Copyright © 2020 ridvanmertoglu. All rights reserved.
//

import UIKit
import CoreData

class SecondViewController: BaseVC, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet private weak var historyTableView: UITableView!
    private var wordArray = [String]()
    private var idArray = [UUID]()
    private var chosenWord = ""
    private var chosenWordId : UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        historyTableView.delegate = self
        historyTableView.dataSource = self
        
        getData()
    }
    
    //Core datadan verileri çekmek için bu fonksiyonu yazdım
    func getData() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate?.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Words")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context?.fetch(fetchRequest)
            
            for result in results as! [NSManagedObject]{ // unwrap force'u ?? yaparak kaldıramadım
                if let word = result.value(forKey: "wordName") as? String {
                    if !(wordArray.contains(word)) && word != "" {
                        self.wordArray.insert(word, at: 0)
                    
                        if let id = result.value(forKey: "id") as? UUID {
                            idArray.append(id)
                        }
                    }
                }
                self.historyTableView.reloadData()
            }
        } catch {
            print("error")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wordArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = wordArray[indexPath.row]
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFirstViewController" {
            let destinationVC = segue.destination as! FirstViewController
            //destinationVC.textField.text = chosenWord
            //destinationVC.selectedWordId = chosenWordId
            print(chosenWord)
            print("entered")
            destinationVC.fetchWordResults(givenWord: chosenWord) // arama ekranına götürüp bu kelimeyi aramış gibi gösterip tanımların oldugu tableView i göstermek istedim fakat olmadı
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenWord = wordArray[indexPath.row]
        chosenWordId = idArray[indexPath.row]
        performSegue(withIdentifier: "toFirstViewController", sender: nil)
    }
}

