//
//  HouseDetailsViewController.swift
//  GameOfThrones
//
//  Created by Amanda Harman on 9/21/16.
//  Copyright © 2016 Amanda Harman. All rights reserved.
//

import UIKit

class HouseDetailsViewController: UIViewController {

    @IBOutlet weak var sigilImage: UIImageView!
    @IBOutlet weak var houseLabel: UILabel!
    @IBOutlet weak var sigilLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    
    var house: House!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if house.name != "Unknown"{
        houseLabel.text = "House of \(house.name!)"
        sigilLabel.text = "Sigil: \(house.sigil!)"
        sigilImage.image = UIImage(named: "\(house.sigil!)")
        }
        else{
            houseLabel.text = "House \(house.name!)"
            sigilLabel.isHidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
