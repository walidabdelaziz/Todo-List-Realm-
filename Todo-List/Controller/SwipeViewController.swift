//
//  SwipeViewController.swift
//  Todo-List
//
//  Created by Walid  on 7/27/20.
//  Copyright © 2020 Walid . All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeViewController: UITableViewController,SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 65.0


    }
    
    // MARK: - Table view data source

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
         
          cell.delegate = self

          return cell
      }
    
    // MARK: - Swipe Methods

    
      func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
            guard orientation == .right else { return nil }

            let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
                // handle action by updating model with deletion
               
                self.updateModel(indexPath: indexPath)
            }

            // customize the action appearance
            deleteAction.image = UIImage(named: "delete-Icon")

            return [deleteAction]
        }
        
        func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
            var options = SwipeOptions()
            options.expansionStyle = .destructive
            return options
        }

    func updateModel(indexPath: IndexPath){
        
    }


}
