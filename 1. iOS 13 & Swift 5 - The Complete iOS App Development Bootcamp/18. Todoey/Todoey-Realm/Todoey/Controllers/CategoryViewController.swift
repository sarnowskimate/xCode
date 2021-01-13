//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Mateusz Sarnowski on 07/05/2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new category for your items", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add category", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.hexColor = UIColor.randomFlat().hexValue()
            
            self.saveCategory(category: newCategory )
        }
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            textField = alertTextField
            textField.placeholder = "Create new category"
        }
        present(alert, animated: true, completion: nil)
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "Categories not created yet"
        cell.backgroundColor = UIColor(hexString: (categories?[indexPath.row].hexColor) ?? "1D9BF6")
//        cell.backgroundColor = UIColor.init(hexString: categories?[indexPath.row].hexColor ?? "#FFFFFF")
//
//
//        var hexColorPath = categories?[indexPath.row].hexColor
//        if hexColorPath == "#FFFFFF" {
//            hexColorPath = UIColor.randomFlat().hexValue()
//            cell.backgroundColor = UIColor.init(hexString: hexColorPath!)
//        } else {
//            cell.backgroundColor = UIColor.init(hexString: hexColorPath!)
//        }
        
        return cell
    }
    
    //MARK: - Manipulation data methods
    
    func saveCategory(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category context: \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategory() {
        categories  = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    //MARK: - Delete data from swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting categories: \(error)")
            }
        }
    }
    
    //MARK: - Seguey
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
}


