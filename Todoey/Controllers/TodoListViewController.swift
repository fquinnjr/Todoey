//
//  ViewController.swift
//  Todoey
//
//  Created by Frank A Quinn on 2018-12-19.
//  Copyright © 2018 Frank A Quinn. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    /* We need to initialize itemArray with all of the items that belong to the category that was selected. */
    var itemArray = [Item]()
    
    /* Category? because it will be Nil until you make up a category & set it in the CatVC Delegate Method. */
    var selectedCategory : Category? {
        /* Everything within didSet block happens only when Category gets set with a value. */
        didSet {
            /* Note below that there is no parameter here so default is used as defined in the function declaration.*/
            loadItems()
            /* So loadItems() is only called when we have a value for our selectedCategory.(We Did Set)(When we've made up a category) */
        }        
        
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //Above we have a shared singleton object which refers to current app as an object
    //We now have access to our AppDelegate as an object.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory
            , in: .userDomainMask))
        
    }
    //MARK TableView DataSource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        /*Let's replace the repetitious references to itemArray[indexPath.row] and replace it with a constant called 'item' */
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //Ternary operator ==>
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
        
    }
    //MARK - TableView Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /* We can delete a value but we must first remove it from our context (Temporary scratchpad) below...*/
        //#####    context.delete(itemArray[indexPath.row])
        /* Remember that itemArray[indexPath.row] is an NSManagedObject that we are deleting above.
         But remember that we still are only deleting it from our context.
         We can't reverse these 2 lines because indexpath.row would be changed before we had a chance to remove the context using indexpath.row as a reference */
        
        //####       itemArray.remove(at: indexPath.row)
        
        /* Still, the above merely updates our itemArray which is used to populate our tableview
         It takes effect after 'self.tableView.reloadData()' below.
         It does nothing to update our core data. We must still Save the context to commit them to our persistent container This is done 2 lines down in the saveItems() function which contains 'context.save()' And then later on in saveItems() we execute tableView.reload. After that we actually SEE the change in the tableview */
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //MARK - Add New items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory /* parentCategory was created in DataModel.*/
            self.itemArray.append(newItem)
            
            self.saveItems()
            
            
            
        }
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "Create new item"
            textField = alertTextfield
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    //MARK: Model Manipulation methods
    
    func saveItems() {
        
        do {
            try context.save() //Commit to permanent storage
            
        } catch {
            print("Error saving context \(error)")
        }
        self.tableView.reloadData()
    }
    /* To tighten code we have changed loadItems(...) to take a parameter of type NSFetchRequest that returns an array of Items. There is an external parameter 'with' that is used outside this function and the internal parameter which is used here called 'request'. Also note that we need a default value '= Item.fetchRequest())' so that we can call loadItems() way above with no parameter at all in the call.*/
    /* Now we are searching among categories so we need to add an additional parameter ...predicate.
     We can still call loadItems with no parameter because we have made the predicate an optional. Note below = Item.fetchRequest() is the default value when no parameters are given such as loadItems(). */
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(),predicate: NSPredicate? = nil) {
        /* We need to query our database and filter the results based on parent category that was selected. */
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        /* Now add the predicate to the request. But we coud possibly unwrap a nil value so we need optional binding with follows the commented out codelines below*/
        //        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate])
        //
        //        request.predicate = compoundPredicate
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        
        do {
            itemArray =  try context.fetch(request)
        } catch {
            print("Error saving data from context \(error)")
        }
        tableView.reloadData()
    }
    
    
}
//MARK: Search bar methods

/*extension extends the viewcontroller to handle Bar methods
 This helps modularize things making them easier to debug our code */
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //To read from the context we need a request that will return an array of Items
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        /*We need to specify now what our query (filter) will be. To do the query we need an NSPedicate method. */
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        /*Above states that for all the items in the itemArray, look for the ones where the title of the item contains %@. "%@" represents the attribute searchBar.text. [cd] makes it Case Diacritic Insensitive. Now we have structured our query and then we add the query to our request. */
        
        
        /* Now we want to sort the data we get back from the database in any order of our choice. */
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        /* Also above we add the sortDescriptorS. (plural naming because it contains an array of sort descriptors). That's why we have square brackets */
        
        /* Next we use the same do catch block as in loadItems() above*/
        //        do {
        //            itemArray =  try context.fetch(request)
        //        } catch {
        //            print("Error saving data from context \(error)")  }
        /* So the results of our query are put in the itemArray */
        
        /* Here the external parameter 'with' is used.*/
        
        loadItems(with: request, predicate: predicate)
    }
    
    /* The above do catch block is now simply replaced with loadItems(NSFetchRequest) which contains all the request assignments which breaks down to loadItems(request: request) which doesn't really make a lot of sense in English so we use an external parameter 'with' in addition to the internal 'request' parameter inside the loadItems function a ways above.*/
    /* Then we need to reload the tableview to see the results in the tableview */
    /*       tableView.reloadData()  changed because it now is containes in loadItems(with: request) */
    
    /* Now we need to detect when the cancel button in the search bar is selected
     We use 'textDidChange' but triggers every time any letter is entered. We need to specify specifically when cancel icon is the at the end of the textfield.
     */
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
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
