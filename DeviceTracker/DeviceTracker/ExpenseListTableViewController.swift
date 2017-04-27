//
//  ExpenseListTableViewController.swift
//  DeviceTracker
//
//  Created by Yogesh Ranjan on 09/04/17.
//  Copyright © 2017 iotguru. All rights reserved.
//

import UIKit
import os.log

class ExpenseListTableViewController: UITableViewController {
    
    //MARK:Properties
    
    var expenses = [Expense]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedExpenses = loadExpenses() {
           expenses = savedExpenses
        }
        
        navigationItem.leftBarButtonItem = editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return expenses.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenseTableViewCell", for: indexPath) as? ExpenseTableViewCell else {
            fatalError("Cannot deque expense table view cell..")
        }
        
        let expense = expenses[indexPath.row]
        cell.amountLabel.text = String(describing: expense.amount)
        cell.expenseCategoryLabel.text = expense.category
        return cell
    }
    
    //MARK: Actions
    @IBAction func unwindExpenseList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? ExpenseDetailsTableViewController {
            let expense = sourceViewController.expense
            mergeExpense(expense, isEditMode: sourceViewController.editMode)
            print ("saving expense....")
            saveExpenses()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch (segue.identifier ?? "") {
        case "addNewExpense" :
            os_log("adding a new expense..", log: .default, type: .debug)
            
        case "showExpenseDetail" :
            guard let expenseDetailViewController = segue.destination as? ExpenseDetailsTableViewController else {
                fatalError("unexpected destination view controller - \(segue.destination)")
            }
            guard let selecteExpenseCell = sender as? ExpenseTableViewCell else {
                fatalError("unexpected sender - \(sender)")
            }
            guard let selectedExpenseIndex = tableView.indexPath(for: selecteExpenseCell) else {
                fatalError("cannot get index for table cell - \(selecteExpenseCell)")
            }
            
            let selectedExpense = expenses[selectedExpenseIndex.row]
            expenseDetailViewController.expense = selectedExpense
        default:
            fatalError("unexpected segue identifier...")
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            expenses.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
        saveExpenses()
    }
    
    //MARK:Private methods
    private func mergeExpense(_ expense: Expense?, isEditMode:Bool) {
        //existing expense category
        if let index = expenses.index(where: {$0.category == expense?.category}) {
            let currentExpense = expenses[index]
            if (isEditMode) {
                currentExpense.amount = (expense?.amount)!
            } else {
                currentExpense.amount += (expense?.amount)!
            }
            //set the latest date of the expesne
            currentExpense.date = (expense?.date)!
            expenses[index] = currentExpense
            tableView.reloadRows(at: [NSIndexPath(item: index, section: 0) as IndexPath], with: .none)
        } else {
            //new expense category
            let newIndexPath = IndexPath(row:expenses.count, section:0)
            expenses.append(expense!)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }
    
    private func saveExpenses() {
        let isSuccessfullSave = NSKeyedArchiver.archiveRootObject(expenses, toFile: Expense.ArchiveURL.path)
        
        if (isSuccessfullSave) {
            os_log("Expenses successfully saved", log: .default, type: .debug)
        } else {
            os_log("Expenses failed to save!", log: .default, type: .error)
        }
    }
    
    private func loadExpenses() -> [Expense]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Expense.ArchiveURL.path) as? [Expense]
    }
}
