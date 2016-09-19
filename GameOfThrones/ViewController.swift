//
//  ViewController.swift
//  GameOfThrones
//
//  Created by Amanda Harman on 9/19/16.
//  Copyright © 2016 Amanda Harman. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController,UITableViewDataSource, UITableViewDelegate{
    

    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    var people = [NSManagedObject]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var managedContext: NSManagedObjectContext?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "\"The List\""
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "Cell")
        managedContext = appDelegate.persistentContainer.viewContext
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetch()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "New Name",message: "Add a new name",preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {
            (action:UIAlertAction) -> Void in
            let textField = alert.textFields!.first
            self.saveName(name: textField!.text!)
            self.tableView.reloadData()})
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action: UIAlertAction) -> Void in}
        
        alert.addTextField { (textField: UITextField) -> Void in}
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert,animated: true, completion: nil)
    }
    @IBAction func searchButtonPressed(_ sender: AnyObject) {
        
        if sender.title == "Search"{
            let alert = UIAlertController(title: "Search",message: "Search for name",preferredStyle: .alert)
            
            let goAction = UIAlertAction(title: "Go", style: .default, handler: {
                (action:UIAlertAction) -> Void in
                let textField = alert.textFields!.first
                self.searchPerson(name: textField!.text!)
                self.tableView.reloadData()
                self.searchButton.title = "Back"
                }
            )
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action: UIAlertAction) -> Void in}
            alert.addTextField { (textField: UITextField) -> Void in}
            alert.addAction(goAction)
            alert.addAction(cancelAction)
            present(alert,animated: true, completion: nil)
            
        }
        
        if sender.title == "Back"{
            self.fetch()
            tableView.reloadData()
            self.searchButton.title = "Search"}
        
    }
    
    
    func fetch(){
        if let managedContext = managedContext{
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
            do {
                let results =
                    try managedContext.fetch(fetchRequest)
                people = results as! [NSManagedObject]
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }
        }
    }
    
    func searchPerson(name: String){
        if let managedContext = managedContext{
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
            fetchRequest.predicate = NSPredicate(format: "name==%@", name)
            do {
                let results =
                    try managedContext.fetch(fetchRequest)
                people = results as! [NSManagedObject]
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }
        }
        
    }
    
    func saveName(name: String) {
        if let managedContext = self.managedContext{
            let entity =  NSEntityDescription.entity(forEntityName: "Person", in:managedContext)
            let person = NSManagedObject(entity: entity!, insertInto: managedContext)
            person.setValue(name, forKey: "name")
            
            do {
                try managedContext.save()
                people.append(person)
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        let person = people[indexPath.row]
        cell!.textLabel!.text = person.value(forKey: "name") as? String
        return cell!
    }
    
    @nonobjc func tableView(_tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action , indexPath) -> Void in
            if let managedContext = self.managedContext{
                managedContext.delete(self.people[indexPath.row] as NSManagedObject)
                self.people.remove(at: indexPath.row)
                do {
                    try managedContext.save()
                } catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                }
                
                self.tableView.deleteRows(at: [indexPath as IndexPath], with: .fade)}})
        
        return [deleteAction]
        
    }
}

