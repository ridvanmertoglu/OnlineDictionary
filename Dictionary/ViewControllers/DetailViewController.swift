//
//  DetailViewController.swift
//  Dictionary
//
//  Created by RIDVAN on 10.02.2020.
//  Copyright © 2020 ridvanmertoglu. All rights reserved.
//

import UIKit

class DetailViewController: BaseVC {
    
    
    @IBOutlet private weak var partOfSpeechLabel: UILabel!
    @IBOutlet private weak var definitionLabel: UILabel!
    @IBOutlet private weak var synonymsLabel: UILabel!
    @IBOutlet private weak var examplesLabel: UILabel!
    
    var selectedPartofSpeech = ""
    var selectedDefinition = ""
    var selectedSynonyms = ""
    var selectedExamples = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        partOfSpeechLabel.text = "TYPE OF WORD\n-----------------\n\(selectedPartofSpeech)"
        definitionLabel.text = "DEFINITION\n-------------\n\(selectedDefinition)"
        synonymsLabel.text = "SYNONMYS\n------------\n\(selectedSynonyms)"
        examplesLabel.text = "EXAMPLE SENTENCES\n-------------------------\n\(selectedExamples)"
          
        

        
        
        
    }
    

    

}
