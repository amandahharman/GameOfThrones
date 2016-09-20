//
//  DetailsViewController.swift
//  GameOfThrones
//
//  Created by Amanda Harman on 9/19/16.
//  Copyright © 2016 Amanda Harman. All rights reserved.
//

import UIKit



class DetailsViewController: UIViewController {

    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var houseLabel: UILabel!

    var person: Person!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = person.name
        houseLabel.text = person.house?.name
 
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }




}
