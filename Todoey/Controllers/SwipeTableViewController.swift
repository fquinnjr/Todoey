//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Frank A Quinn on 2019-02-25.
//  Copyright © 2019 Frank A Quinn. All rights reserved.
//

import UIKit
import SwipeCellKit
import ChameleonFramework
class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80.0
       
    }
   // MARK: TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /*Here is where we want to initialize the SwipeTableView cell as the default cell for all of the tableviews that inherit this class. */
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self

        return cell
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        /* Guard ensures that the user swipes only from the right. */
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            
            // handle action when cell gets swiped...updating model with deletion
          self.updateModel(at: indexPath)
   
            
        }
        
//MARK: customize the action appearance...What image appears after the swipe.
        deleteAction.image = UIImage(named: "delete-icon")
        /* return the delete action in response to the user's swipe. */
        return [deleteAction]
    }
    /* This is another cut and paste from SwipeCellKit website API. */
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        
        return options
    }
    //MARK: New update model func. This is needed because our superclass can't know anything about it's child classes so we must create a seperate func that our child classes can call to update the data.
/*Remember 'at' is the external parameter and 'indexPath' is the internal parameter. */
    func updateModel(at indexPath:IndexPath) {
      //update our data Model
        print("Item Deleted from Superclass")
    }
}

