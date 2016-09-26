//
//  ViewController.swift
//  GameOfThrones
//
//  Created by Amanda Harman on 9/19/16.
//  Copyright © 2016 Amanda Harman. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON

class ViewController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    lazy var managedContext: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }()
    
    var fetchedResultsController: NSFetchedResultsController<NSManagedObject>?
    let searchController = UISearchController(searchResultsController: nil)
    var selectedPerson: Person?
    var selectedHouse: House?
            let houseFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "House")
       let peopleFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
    @IBOutlet weak var filterButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Directory"
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "Cell")
        self.view.addSubview(tableView)
        initializeFetchedResultsController(request: peopleFetchRequest)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        do{
            if try self.managedContext.count(for: houseFetchRequest) == 0{
                buildHouses()
            }}
            
        catch {
            print("Error")
            return
        }

          }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func buildHouses(){
        let asset = NSDataAsset(name: "houses", bundle: Bundle.main)
        let json = JSON(data: asset!.data)
            for item in json["houses"].arrayValue {
                guard let houseEntity = NSEntityDescription.insertNewObject(forEntityName: "House", into:  self.managedContext) as? House else {return}
                    houseEntity.name = item["name"].stringValue
                    houseEntity.sigil = item["sigil"].stringValue
                    do {
                        try self.managedContext.save()
                
                        }catch {
                        print("There was an error saving")
                        return
                    }

            }

    }
    
    func initializeFetchedResultsController(request: NSFetchRequest<NSFetchRequestResult>){
        let  fetchRequest = request
        let primarySortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.predicate = nil
        fetchRequest.sortDescriptors = [primarySortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest as! NSFetchRequest<NSManagedObject>,
            managedObjectContext: self.managedContext,
            sectionNameKeyPath: "firstLetter",
            cacheName: nil)
        fetchedResultsController?.delegate = self
        
        do{
            try
                fetchedResultsController?.performFetch()}
            
        catch{
            print("Fetch failed")
        }
    }
  
    
    func filterContentForSearchText(searchText: String) {
        if searchController.isActive {
            NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: view, attribute:.top, multiplier: 1, constant: 0).isActive = true
            
            let predicate = NSPredicate(format: "name== %@", searchText)
            self.fetchedResultsController?.fetchRequest.predicate = predicate
            
            do {
                try self.fetchedResultsController?.performFetch()
            } catch {
                let fetchError = error as NSError
                print("\(fetchError), \(fetchError.userInfo)")
            }
            
            tableView.reloadData()
            
        }
        else{
            self.fetchedResultsController?.fetchRequest.predicate = nil
            
            do {
                try self.fetchedResultsController?.performFetch()
            } catch {
                let fetchError = error as NSError
                print("\(fetchError), \(fetchError.userInfo)")
            }
            tableView.reloadData()
        }
    }
    
    @IBAction func filterButtonPressed(_ sender: UIBarButtonItem) {
        if sender.title == "Name"{
            sender.title = "House"
            initializeFetchedResultsController(request: peopleFetchRequest)
            tableView.reloadData()
         
            
        }
        else if sender.title == "House"{
            sender.title = "Name"
            initializeFetchedResultsController(request: houseFetchRequest)
            tableView.reloadData()
        }
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "New Name",message: "Add a new name",preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {
            (action:UIAlertAction) -> Void in
            let textField = alert.textFields!.first
            guard let person = NSEntityDescription.insertNewObject(forEntityName: "Person", into: self.managedContext) as? Person else {return}
            person.name = textField?.text
            if (person.name?.contains("Stark"))!{
                do {
                    let fetchRequest = self.houseFetchRequest
                    fetchRequest.predicate = NSPredicate(format: "name==%@", "Stark")
                    try person.house = self.managedContext.fetch(fetchRequest).first as? House
                    person.house?.addToPerson(person)
                    
                }catch {
                    print("There was an error saving")
                    return
                }
            }
            else {
                do {
                    let fetchRequest = self.houseFetchRequest
                    fetchRequest.predicate = NSPredicate(format: "name==%@", "Unknown")
                    try person.house = self.managedContext.fetch(fetchRequest).first as? House
                    person.house?.addToPerson(person)
                    
                }catch {
                    print("There was an error saving")
                    return
                }
            }
            
            do {
                try self.managedContext.save()
                
            }catch {
                print("There was an error saving")
                return
            }
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action: UIAlertAction) -> Void in}
        
        alert.addTextField { (textField: UITextField) -> Void in}
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert,animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toDetails"{
            let destinationVC : DetailsViewController = segue.destination as! DetailsViewController
                destinationVC.person = selectedPerson}
   


        if segue.identifier == "toHouseDetails"{
            let destinationVC : HouseDetailsViewController = segue.destination as! HouseDetailsViewController
            destinationVC.house = selectedHouse
        }
    }
    
    
    
}

extension ViewController:NSFetchedResultsControllerDelegate{
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            self.tableView.deleteRows(at: [indexPath! as IndexPath], with: .fade)
        case .update:
     
            guard let indexPath = indexPath ,let cell = tableView.cellForRow(at: indexPath) else {return}
            
                    configureCell(cell: cell, object: controller.object(at: indexPath) as! NSManagedObject)
            
                tableView.reloadRows(at: [indexPath], with: .fade)

       
        case .move:
            tableView.deleteRows(at: [indexPath!], with: UITableViewRowAnimation.fade)
            tableView.insertRows(at: [newIndexPath!], with: UITableViewRowAnimation.fade)
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(NSIndexSet(index:sectionIndex) as IndexSet, with: .fade)
        case .delete:
            tableView.deleteSections(NSIndexSet(index:sectionIndex) as IndexSet, with: .fade)
        default:
            break
        }
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController?.sections else {
            return 0
        }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if let object = fetchedResultsController?.object(at: indexPath){
            configureCell(cell: cell, object: object)}
        
        return cell
        
    }
    
    @nonobjc func tableView(_tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func configureCell(cell: UITableViewCell, object: NSManagedObject){
        if let person = object as? Person{
        cell.textLabel?.text = person.name
        }
        else if let house = object as? House{
            cell.textLabel?.text = house.name
        }
    }
    

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController?.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sections = fetchedResultsController?.sections else {return nil}
        let currentSection = sections[section]
        return currentSection.name
    }
}

extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action , indexPath) -> Void in
            if let record = self.fetchedResultsController?.object(at: indexPath){
                self.managedContext.delete(record)}
            
        })
        
        return [deleteAction]
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if  self.filterButton.title == "House"{
        if let person = fetchedResultsController?.object(at: indexPath) as? Person{
            selectedPerson = person
            performSegue(withIdentifier: "toDetails", sender: self)
            }}
   
       else if self.filterButton.title == "Name"{
    if let house = fetchedResultsController?.object(at: indexPath) as? House{
        selectedHouse = house
        performSegue(withIdentifier: "toHouseDetails", sender: self)
    }
}
    }

}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
        
    }
    
}
