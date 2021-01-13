//
//  ResultsViewController.swift
//  Tipsy
//
//  Created by Mateusz Sarnowski on 30/03/2020.
//  Copyright © 2020 The App Brewery. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {
    
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var settingsLabel: UILabel!
    var finalResult = "0"
    var finalTip = 0
    var finalSplit = 2
    
    override func viewDidLoad() {
    super.viewDidLoad()
        totalLabel.text = finalResult
        settingsLabel.text = "Split between \(finalSplit) people, with \(finalTip) tip."
    }
    
    @IBAction func recalculatePressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
