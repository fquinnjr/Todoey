//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Frank A Quinn on 2019-01-19.
//  Copyright © 2019 Frank A Quinn. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categories = [Category]()
    /* The context communicates with our persistent container. It makes CRUD possible. */
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }
    
    
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        
        cell.textLabel?.text = categories[indexPath.row].name
        
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
            destinationVC.selectedCategory = categories[indexPath.row] /*note lowercase local indewPath above, NOT IndexPath */
        }
        
        
        }

    //MARK: - Data Manipulation Methods
    
    func saveCategories() {
        
        do {
            try context.save() //Commit to permanent storage
            
        } catch {
            print("Error saving category \(error)")
        }
        tableView.reloadData()
    }
    
    
    
    
    func loadCategories() {
        
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do {
            categories = try context.fetch(request)
        } catch {
            print("Error loading Categories \(error)")
        }
        tableView.reloadData()
    }
    
    
    
    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category(context: self.context)
            
            newCategory.name = textField.text!
/* We grab a reference to the category and then add it to the array. */
            self.categories.append(newCategory)
            
            self.saveCategories()
            
            
            
        }
        alert.addAction(action)
        alert.addTextField { (field) in
            textField = field
            field.placeholder = "Add a new Category"
            
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    
}
