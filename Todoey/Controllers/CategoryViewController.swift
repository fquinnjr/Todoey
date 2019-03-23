//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Frank A Quinn on 2019-01-19.
//  Copyright © 2019 Frank A Quinn. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
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
        tableView.separatorStyle = .none
    }
    
    
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /* categories is now an optional so the following is no longer valid.
         return categories.count. */
        
        return categories?.count ?? 1
        /*The above states that if categories is Not nil then return count otherwise return 1. So then our tableview would have only one row. This syntax is referred to as the Nil Coalescing Operator. ?? */
    }
    //   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
    //        cell.delegate = self
    //        return cell
    //    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        /* We tap into the cell that gets created in our new superclass. Therefore the cell is now a SwipeCell created bythe SwipeTableViewController.swift defn.*/
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        /* Next we fill in the textfield with the name of the category if there is a category otherwise "No Categories Added Yet" is displayed in textfield. */
        
        if let category = categories?[indexPath.row]{
            cell.textLabel?.text = category.name
            guard let categoryColour = UIColor(hexString: category.colour) else {fatalError()}
            
            cell.backgroundColor = categoryColour
            cell.textLabel?.textColor = ContrastColorOf(categoryColour, returnFlat: true)
        }
        
        
        
        
//        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
//        cell.backgroundColor = UIColor(hexString: categories?[indexPath.row].colour ?? "1D9BF6")
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    /* This is what happens when we click on any of our cells. */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        /* The above segue takes us to our TodoListViewController. BUT we first create a new instance of our destinationVC and then set our destinationVC's selectedCategory to the category that was selected. (SEE... if let...  below...*/
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListViewController
        
        /* We need to grab the category that corresponds to the selected cell. Since it can possibly contain nil we must use optional binding. */
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
            /*note lowercase local indexPath above, NOT IndexPath. Note also that categories is now an optional ? from changes made above. */
        }
        
        
    }
    
    //MARK: - Data Manipulation Methods(Save,Load and Delete)
    /*Next we pass in the new category that we created into the save function. */
    func save(category: Category) {
        /*The write method commits changes to our Realm. The changes we want to make is we want to add our new cayegory to the Realm. */
        do {
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
    //MARK: Delete Data from Swipe
    /* So now we are making a call to the updateModel func that we created in the superclass. */
    override func updateModel(at indexPath: IndexPath) {
        /*BUT because we have overrided the func we must make a direct call to the superclass updateModel as well.*/
        super.updateModel(at: indexPath)
        if let categoryForDeletion = self.categories?[indexPath.row]{
            do {
                try realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting category, \(error)")
            }
        }
    }
    
    
    
    
    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        /* Next when we click on the add button then we create a new category object. */
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            /*  simply assign as a category object. */
            let newCategory = Category()
            
            /* name and colour are now initialized in the Category.swift file. */
            newCategory.name = textField.text!
            newCategory.colour = UIColor.randomFlat.hexValue()
            /*Note that hexValue above is a string type. */
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

