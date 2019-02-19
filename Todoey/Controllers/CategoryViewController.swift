//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Frank A Quinn on 2019-01-19.
//  Copyright © 2019 Frank A Quinn. All rights reserved.
//

import UIKit
import RealmSwift


class CategoryViewController: UITableViewController {
  /* We initialize a new Realm object, which serves as an access point to our Realm database */
    let realm = try! Realm()
    

 /* Force unwrap is not safe so we turn categories into an optional instead of...
    var categories : Results<Category>!...*/
    var categories: Results<Category>?
    /* Results is an auto-updating container type in Realm returned from Object queries. So we don't use arrays anymore as we did in CoreData. */
    
    /* The context communicates with our persistent container. It makes CRUD possible. BUT NOW WE DON'T NEED CONTEXT WHEN USING Realm.
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext. */
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
 /*We load up all the categories that we currently have. (See loadCategories function.)*/
        loadCategories()
    }
    
    
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
/* categories is now an optional so the following is no longer valid.
        return categories.count. */
        
       return categories?.count ?? 1
/*The above states that if categories is Not nil then return count otherwise return 1. So then our tableview would have only one row. This syntax is referred to as the Nil Coalescing Operator. ?? */
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories added yet."
   /*The above states that if categories is Not nil then return the name string of the item at the indexpath otherwise return "No Categories added yet." This is another example of using the Nil Coalescing Operator. ?? */
        return cell
        
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        let destinationVC = segue.destination as! TodoListViewController
        
 /* We need to grab the category that corresponds to the selected cell. Since it can possibly contain nil we must use optional binding. */
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
            /*note lowercase local indewPath above, NOT IndexPath. Note also that categories is now an optional ? from changes made above. */
        }
        
        
        }

    //MARK: - Data Manipulation Methods
    
    func save(category: Category) {
 /*We pass in the new Category that was created into the save function*/
        do {
 /* old CoreData method to commit to permanent storage...
                       try context.save()
             But now we use our Realm persistent data store method.*/
            
            try realm.write {
            realm.add(category)
            }
        } catch {
            print("Error saving category \(error)")
        }
        tableView.reloadData()
    }
    
    
    
    
    func loadCategories() {
/* A single line will replace all the above CoreData code when using Realm. The following syntax pulls out ALL of the items inside our Realm that are Category objects. Note that categories is a Results collection type and it is not very easily converted so we will change the datatype of our Category. */
        
        categories = realm.objects(Category.self)
  /*      The single line above replaces all the CoreData code by using Realm.
         It basically says look inside our Realm and return all the objects that are of the Category type and assign it to categories.*/
        tableView.reloadData()
/*The above line calls all the TableView Datasource methods again. */
    }
//previous code from CoreData was used above instead of Realm.
//        let request : NSFetchRequest<Category> = Category.fetchRequest()
//        do {
//            categories = try context.fetch(request)
//        } catch {
//            print("Error loading Categories \(error)")
//        }
       
    
    
    
    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
  /*   We are no longer using CoreData so we don't need to save to a context like we did before as follows...
             let newCategory = Category(context: self.context) .
             Now it is as so... simply assign as a category object. */
            let newCategory = Category()
            
 /* Name is now initialized in the Category.swift file. */
            newCategory.name = textField.text!
            
/* In CoreData we grab a reference to the category and then add it to the array.
             But we don't need append with realm because the Result type is an autoupdating container type. */
           // self.categories.append(newCategory)
            
            /* saveCategories was previously used to save the context (we don't need context with Realm) */
            self.save(category: newCategory)
    /*The save function above uses the write and add methods which are Realm methods. */
            
            
        }
        alert.addAction(action)
        alert.addTextField { (field) in
            textField = field
            field.placeholder = "Add a new Category"
            
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    
}
