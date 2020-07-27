//
//  ViewController.swift
//  Todo-List
//
//  Created by Walid  on 7/26/20.
//  Copyright © 2020 Walid . All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeViewController {
    
    let realm = try! Realm()
    
    var categories: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.separatorStyle = .none
        loadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else {
            fatalError()
        }
        navBar.backgroundColor = UIColor(hexString: "007AFF")
    }
   
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row]{
            cell.textLabel?.text = category.name
            if let colorHex = UIColor(hexString: category.color){
                cell.backgroundColor = colorHex
                cell.textLabel?.textColor = ContrastColorOf(backgroundColor: colorHex, returnFlat: true)
            }
        }else {
            cell.textLabel?.text = "No categories added!"
            cell.backgroundColor = UIColor(hexString: "007AFF")

        }

        return cell
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ItemViewController
        if let indexpath = tableView.indexPathForSelectedRow{
            destination.selectedCategory = categories?[indexpath.row]
        }
    }
    
    // MARK: - adding and loading and deleting data

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.color = UIColor.randomFlat().hexValue()
            self.saveData(category: newCategory)
            
        }
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        present(alert, animated: true, completion: nil)
    }
    
    func saveData(category: Category){
        do{
           try realm.write{
                realm.add(category)
            }
        }catch{
            print("There is an error while saving data \(error)")
        }
        tableView.reloadData()
    }
    
    func loadData(){
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    
    override func updateModel(indexPath: IndexPath) {
        if let categoryDeletion = self.categories?[indexPath.row]{
            do{
                try realm.write{
                    realm.delete(categoryDeletion)
                }
            }catch{
                print("There is an error while deleting data \(error)")
            }
        }
    }
    
   
}
