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
    @IBOutlet weak var sigilLabel: UILabel!
    @IBOutlet weak var sigilImage: UIImageView!

    var person: Person!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        nameLabel.text = person.name
        if let house = person.house{
        houseLabel.text = "House: \(house.name!)"
        sigilLabel.text = "Sigil: \(house.sigil!)"
        sigilImage.image = UIImage(named: "\(house.sigil!)")
        }
 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }




}
