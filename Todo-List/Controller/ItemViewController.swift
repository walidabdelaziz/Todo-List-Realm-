//
//  ItemViewController.swift
//  Todo-List
//
//  Created by Walid  on 7/27/20.
//  Copyright © 2020 Walid . All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ItemViewController: SwipeViewController {
    
    let realm = try! Realm()
    
    var todoItems: Results<Item>?

    
    var selectedCategory: Category? {
        didSet{
            loadData()
        }
    }
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorStyle = .none
        searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchBar.placeholder = "Search here"
        if let color = selectedCategory?.color{
            title = selectedCategory?.name
            guard let navBar = navigationController?.navigationBar else {
                fatalError()
            }
            if let navColor = UIColor(hexString: color){
                navBar.tintColor = ContrastColorOf(backgroundColor: navColor, returnFlat: true)
                navBar.backgroundColor = navColor
                navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(backgroundColor: navColor, returnFlat: true)]
                searchBar.barTintColor = navColor
                
            }
        }
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
            if let color = UIColor(hexString: selectedCategory?.color).darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)){
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(backgroundColor: color, returnFlat: true)
                
            }
        }else{
            cell.textLabel?.text = "No items added!"
        }
        return cell
    }
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // updating data
        
        if let item = todoItems?[indexPath.row]{
            do{
            try realm.write{
                item.done = !item.done
            }
            }catch{
                print("There is an error while updating data \(error)")

            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - adding and loading and deleting data

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            // Saving data
            if let currentCateogry = self.selectedCategory{
                do{
                    try self.realm.write{
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCateogry.items.append(newItem)
                    }
                }catch{
                    print("There is an error while saving data \(error)")
                }
                self.tableView.reloadData()
            }
        }
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        present(alert, animated: true, completion: nil)

    }
    
    func loadData(){
        todoItems = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }
    
    override func updateModel(indexPath: IndexPath) {
        if let itemDeletion = todoItems?[indexPath.row]{
            do{
                try realm.write{
                    realm.delete(itemDeletion)
                }
            }catch{
                print("There is an error while deleting data \(error)")
            }
        }
    }
    
}
extension ItemViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter(NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadData()
            DispatchQueue.main.async {
                self.searchBar.resignFirstResponder()
            }
        }
    }
}
