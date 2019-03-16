//
//  ViewController.swift
//  Todoey
//
//  Created by Frank A Quinn on 2018-12-19.
//  Copyright © 2018 Frank A Quinn. All rights reserved.
//

import UIKit


import RealmSwift

class TodoListViewController: SwipeTableViewController {
   
    var todoItems : Results<Item>?
    
    let realm = try! Realm()
    
    /* Category? because it will be Nil until you make up a category & set it in the CatVC Delegate Method. */
    var selectedCategory : Category? {
        /* Everything within didSet block happens only when Category gets set with a value. */
        didSet {
            /* Note below that there is no parameter here so default is used as defined in the function declaration.*/
            loadItems()
            /* So loadItems() is only called when we have a value for our selectedCategory.(We Did Set)(When we've made up a category) */
        }        
        
    }
    
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //Above is used for CoreData method
    //Above we have a shared singleton object which refers to current app as an object
    //We now have access to our AppDelegate as an object.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory
            , in: .userDomainMask))
        
    }
    //MARK: - TableView DataSource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1 /*Nil Coalescing Operator.Optional Chaining*/
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   /*Now that we are inheriting from the SwipeViewCell so we need to use the superclass's cell instead so the following is taken out...
       let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath) ...the dequeue is now inhereited from the superclass so replace with...*/
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        /* We now use optional binding below */
        
        if let item = todoItems?[indexPath.row]{
        
        cell.textLabel?.text = item.title
        
        //Ternary operator ==>
            // value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        return cell
        
    }
    //MARK: - TableView Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //MARK: Realm ...New way of persistent storage
/* if let makes sure todoItems is not nil. If not nil then the row item is assigned to item variable , then we toggle the done boolean property to be the opposite of what it was before and write it to the realm persistent storage.*/
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                 
                item.done = !item.done
                }
            } catch {
                print("Error saving done status, \(error)")
            }
            
        }
/* tableView.reloadData() calls the cellForRowAtindexPath method again to update our cells based on the done property.*/
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //MARK: - Add New items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
 /*what happens when the user clicks the Add Item button on our UIAlert*/
            
            if let currentCategory = self.selectedCategory {
  /*if let above ensures the following only happens after we have unwrapped our self.selectedCategory. */
                do {
                try self.realm.write {
                    let newItem = Item()/*create a new item*/
                    newItem.title = textField.text!/*give it the title entered in the textfield */
                   newItem.dateCreated = Date()
                    currentCategory.items.append(newItem)/*append it to the items in the current category */
 /* Above lines show that we no longer have to use the parentCategory property from item.swift file as we setup in CoreData method.*/
                }
                } catch {
                    print("Error saving new items, \(error)")
                }
            }
            

          self.tableView.reloadData()
            
            
        }
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "Create new item"
            textField = alertTextfield
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    //MARK: Model Manipulation methods
 /* all left over from CoreData below*/
//    func saveItems() {
//
//        do {
//            try context.save() //Commit to permanent storage
//
//        } catch {
//            print("Error saving context \(error)")
//        }
//        self.tableView.reloadData()
//    }
   
   
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title",ascending: true)
        

        

        tableView.reloadData()
    }
    /* Now we are inheriting from SwipeTableView class. So the following indexpath gets passed in from the superclass*/
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
           try realm.write {
                realm.delete(item)
            }
            } catch {
              print("Error deleting Item, \(error)")
        }
    }
    }
}
//MARK: Search bar methods

/*extension extends the viewcontroller to handle Bar methods
 This helps modularize things making them easier to debug our code */

extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
 /*Note that the filter takes an NSPredicate as it's input.  %@ is the argument that we will pass in.*/
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
       /* The one line above replaces all 4 of the following lines left over from CoreData methodology. */
        tableView.reloadData()
    }
 /* To better understand all the search functionality in Realm, just checkout the Realm NSPredicate Cheat Sheet online. */
    
    
/* THE FOLLOWING IS LEFT OVER FROM COREDATA */
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItems(with: request, predicate: predicate)
    

 
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
 /* We loadItems when we dismiss the searchBar. */
        if searchBar.text?.count == 0 {
            loadItems()
            
            
            /*Get the dispatch on the main cue and run resignFirstResponder on the main cue. */
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

            /*Above asks the object (searchBar) to relinquish status as FirstResponder so that the cursor and keyboard both go away.
             So go back to the original state in the background. */
            /* We usually want to run lengthy processes in the Background Thread and not on the Main Thread so our app doesn't have to wait. When the Background Thread completes the results are then passed back to the main thread. But we need to grab the main thread in this case even though background processes are running so that we can dismiss the search bar focus. To do that we need the dispatch cue.*/
        }
    }
}
