//
//  ExpenseDetailsTableViewController.swift
//  DeviceTracker
//
//  Created by Yogesh Ranjan on 09/04/17.
//  Copyright © 2017 iotguru. All rights reserved.
//

import UIKit

class ExpenseDetailsTableViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var expense:Expense?
    var editMode:Bool = false
    
    var category:String = "" {
        didSet {
            categoryLabel.text = category
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        amountTextField.keyboardType = UIKeyboardType.decimalPad
        
        if let expense = expense {
            amountTextField.text = String(describing: expense.amount)
            category = expense.category
            datePicker.date = expense.date
            self.editMode = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            amountTextField.becomeFirstResponder()
        }
    }
    
    //MARK: Actions
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        let isPresentingVCInAddMode = presentingViewController is UITabBarController
        if (isPresentingVCInAddMode) {
            dismiss(animated: true, completion: nil)
        } else if let owningNavigationVC = navigationController {
            owningNavigationVC.popViewController(animated: true)
        } else {
            fatalError("The ExpenseDetailViewController is not inside a navigation controller.")
        }
    }
    
    
    
    @IBAction func unwindToExpeneDetails(sender: UIStoryboardSegue) {
        if let expenseCategoryViewController = sender.source as? ExpenseCategoryPickerViewController {
            let category = expenseCategoryViewController.selectedCategory
            self.category = category!
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PickCategory" {
            if let expeneseCategoryPickerViewController  = segue.destination as? ExpenseCategoryPickerViewController {
                expeneseCategoryPickerViewController.selectedCategory = category
            }
        }
        
        if segue.identifier == "SaveExpense" {
            expense = Expense(category: category, amount: Decimal(string: amountTextField.text!)!, date:datePicker.date)
        }
    }
    
    
    //MARK: TextField delegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet.init(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    
    
}
