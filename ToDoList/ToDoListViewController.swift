//
//  ViewController.swift
//  ToDoList
//
//  Created by Aakash Adhikari on 6/3/20.
//  Copyright © 2020 Aakash Adhikari. All rights reserved.
//  CRUD
//  Create, Read, update Destroy

import UIKit
import CoreData

class ToDoListViewController: UITableViewController{
    
    //    @Environment(\.managedObjectContext) var moc
    //    @FetchRequest(entiry: Country.entiry(), sortDescriptors: []) var countries: FetchResults<Country>
    
    // var itemArray = ["Buy Slippers", "Buy Wet Suit", "Buy Surf Board"]
    var itemArray = [String]()
    // let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        retrieveData()
    }
    
    func addNewItems(textField: String){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Now let’s create an entity and new user records.
        let userEntity = NSEntityDescription.entity(forEntityName: "Things", in: managedContext)!
        
        let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
        user.setValue(textField, forKeyPath: "items")
        
        do {
            try managedContext.save()
            self.tableView.reloadData()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        
    }
    
    func retrieveData() {
        
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Prepare the request of type NSFetchRequest for the entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Things")
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            
            
            for data in result as! [NSManagedObject] {
                
                guard let dataString = data.value(forKey: "items") as? String else {return}
                
                if itemArray.contains(dataString) {
                    
                }else {
                    itemArray.append(dataString)
                    
                }
                
                
                print(dataString)
            }
            tableView.reloadData()
        } catch {
            
            print("Failed")
        }
    }
    
    
    //MARK: - Add New Item
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        //let textField = UITextField()
        
        // Create the alert controller
        let alertController = UIAlertController(title: "Add Item In List", message: "", preferredStyle: .alert)
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Add Item"
            
            // Create the actions
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                (action) in
                
                self.addNewItems(textField: textField.text!)
                self.retrieveData()
                //    self.itemArray.append(textField.text!)
                //
                //            //Save update Item Array to User Defaults
                //            self.defaults.set(self.itemArray, forKey: "To Do List.")
                //
                //            if let items = self.defaults.array(forKey: "To Do List") as? [String] {
                //                self.itemArray = items
                //            }
                
                self.tableView.reloadData()
                
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
                UIAlertAction in
            }
            
            // Add the actions
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            
            // Present the controller
            self.present(alertController, animated: true, completion: nil)
            
        }
        
    }
    
    
    //MARK: - Delete Items
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            
            delete(str: itemArray[indexPath.row])
            
            itemArray.remove(at: indexPath.row)
            
            // tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
        self.tableView.reloadData()
        
    }
    
    func update(str: String, str2: String){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Prepare the request of type NSFetchRequest for the entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Things")
        
        fetchRequest.predicate = NSPredicate(format: "items = %@", str)
        
        do
               {
                   let test = try managedContext.fetch(fetchRequest)
                   
                   let objectToUpdate = test[0] as! NSManagedObject
                objectToUpdate.setValue(str2, forKey: "items")
                   do{
                       try managedContext.save()
                   }
                   catch
                   {
                       print(error)
                   }
                   
               }
               catch
               {
                   print(error)
               }
        
        
        
        
    }
    
    func delete(str: String){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Prepare the request of type NSFetchRequest for the entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Things")
        
        fetchRequest.predicate = NSPredicate(format: "items = %@", str)
        
        do
        {
            let test = try managedContext.fetch(fetchRequest)
            
            let objectToDelete = test[0] as! NSManagedObject
            managedContext.delete(objectToDelete)
            
            do{
                try managedContext.save()
            }
            catch
            {
                print(error)
            }
            
        }
        catch
        {
            print(error)
        }
        
    }
}

extension ToDoListViewController {
    
    // Return the number of rows for the table.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    // Provide a cell object for each row.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Fetch a cell of the appropriate type.
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        // Configure the cell’s contents.
        cell.textLabel?.text = itemArray[indexPath.row]
        print(cell)
        return cell
    }
    
}

extension ToDoListViewController {
    
    // Tells the delegate that the specified row is now selected.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == .checkmark
            {
                cell.accessoryType = .none
            }
            else
            {
                cell.accessoryType = .checkmark
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        let alertController = UIAlertController(title: "Update List", message: "", preferredStyle: .alert)
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Add Item"
            textField.text = self.itemArray[indexPath.row]
            
            // Create the actions
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                (action) in
                
               // self.addNewItems(textField: textField.text!)
                self.update(str: self.itemArray[indexPath.row] , str2: textField.text!)
                self.itemArray.remove(at: indexPath.row)
                self.retrieveData()
                
                
                self.tableView.reloadData()
                
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
                UIAlertAction in
            }
            
            // Add the actions
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            
            // Present the controller
            self.present(alertController, animated: true, completion: nil)
            
        }
        
    }
    
    
}


