//
//  ViewController.swift
//  Todoey
//
//  Created by Frank A Quinn on 2018-12-19.
//  Copyright © 2018 Frank A Quinn. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory
        , in: .userDomainMask).first?.appendingPathComponent("Items.plist")//get first item in user's Document/ home directory
  //   let defaults = UserDefaults.standard // only used for user default method
    
    //dataFilePath is a global constant up here
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
        
        
        print(dataFilePath!)
 //Following were just stub files to put in test data
//        let newItem = Item()
//        newItem.title = "Find Mike"
//        itemArray.append(newItem)
//
//        let newItem2 = Item()
//        newItem2.title = "Buy Eggos"
//        itemArray.append(newItem2)
//
//        let newItem3 = Item()
//        newItem3.title = "Destroy Demorgogon"
//        itemArray.append(newItem3)

        loadItems()
        
        // items is cast as an [Item] object array
   /*     if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
            itemArray = items
        }
 */
    }
    //MARK TableView DataSource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        //Let's replace the repetitious references to itemArray[indexPath.row] and replace it with a constant called 'item'
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //        if item.done == true {
        //            cell.accessoryType = .checkmark
        //        } else {
        //
        //         cell.accessoryType = .none
        //    }
        //We have replaced the above lines using the Ternary operator of the form...
        // value = condition ? valueIfTrue : valueIfFalse like so...
        
        //     cell.accessoryType = item.done == true ? .checkmark : .none
        //Believe it or not we can even elimate == true to abbreviate like this...
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
        
    }
    //MARK - TableView Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Now we toggle checkmark boolean
        //        if itemArray[indexPath.row].done == false {
        //            itemArray[indexPath.row].done = true
        //        } else {
        //            itemArray[indexPath.row].done = false
        //        }
        //All of the above can be replaced with the ! NOT operator
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //MARK Add New items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            //what will happen when user hits add
            let newItem = Item() //done property is false in Data Model item.swift
            
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            
            self.saveItems()
            
            //Let's setup persistent storage using user defaults
            //Not using defaults anymore...
       //     self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
           
        }
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "Create new item"
            textField = alertTextfield
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
//MARK - Model Manipulation methods
    
    func saveItems() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
            
        } catch {
            print("Error encoding item Array, \(error)")
        }
        self.tableView.reloadData()
    }
    func loadItems() {
        //We intentionally make try and optional so that we can use optional binding to unwrap it safely
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
            itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding Item array, \(error)")
            }
        }
    }
}
