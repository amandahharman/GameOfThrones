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
            if let set = house.value(forKey: "person") as? NSSet{
                if set.count == 0{
                    countLabel.text = "There are none in this house"
                }
                else if set.count == 1{
                    countLabel.text = " There is \(set.count) in this house."
                }
                else{
                    countLabel.text = " There are \(set.count) in this house."

                }
            }
    
        }
        else{
            houseLabel.text = "House \(house.name!)"
            sigilLabel.isHidden = true
            if let set = house.value(forKey: "person") as? NSSet{
                if set.count == 0{
                    countLabel.text = "There are none in this house"
                }
                else if set.count == 1{
                    countLabel.text = " There is \(set.count) in this house."
                }
                else{
                    countLabel.text = " There are \(set.count) in this house."
                    
                }
            }
            

        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
