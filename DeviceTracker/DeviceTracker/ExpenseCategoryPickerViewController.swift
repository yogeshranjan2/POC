//
//  ExpenseCategoryPickerViewController.swift
//  DeviceTracker
//
//  Created by Yogesh Ranjan on 11/04/17.
//  Copyright © 2017 iotguru. All rights reserved.
//

import UIKit

class ExpenseCategoryPickerViewController: UITableViewController {
    
    let categoryList:[String] = ["Grocery", "Telephone", "Maid", "Misc", "Entertainment", "Utility"]
    
    var selectedCategoryIndex:Int?
    
    var selectedCategory:String? {
        didSet {
            if let category = selectedCategory {
                selectedCategoryIndex = categoryList.index(of: category)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Actions
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SaveSelectedCategory" {
            if let cell = sender as? UITableViewCell {
                let indexPath = tableView.indexPath(for: cell)
                if let index = indexPath?.row {
                    selectedCategory = categoryList[index]
                }
            }
        }
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoryList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = categoryList[indexPath.row]
        
        if (selectedCategoryIndex == indexPath.row) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let index = selectedCategoryIndex {
            let cell = tableView.cellForRow(at: NSIndexPath(item: index, section: 0) as IndexPath)
            cell?.accessoryType = .none
        }
        
        selectedCategory = categoryList[indexPath.row]
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        
    }
}
