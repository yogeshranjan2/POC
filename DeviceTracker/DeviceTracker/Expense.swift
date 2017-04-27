//
//  Expense.swift
//  DeviceTracker
//
//  Created by Yogesh Ranjan on 09/04/17.
//  Copyright © 2017 iotguru. All rights reserved.
//

import Foundation
import os.log

class Expense : NSObject, NSCoding {
    
    //MARK:Properties
    
    var category:String
    var amount:Decimal
    var date:Date
    
    //MARK: Types
    
    struct PropertyKey {
        static let category = "category"
        static let amount = "amount"
        static let date = "date"
    }
    
    //MARK: Archiving file paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("expenses")
    
    //MARK:Initialization
    
    init?(category:String, amount:Decimal, date:Date) {
        if (category.isEmpty || amount < 0) {
            return nil
        }
        self.category = category
        self.amount = amount
        self.date = date
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let category = aDecoder.decodeObject(forKey: PropertyKey.category) as? String else {
            fatalError("cannot decode category string")
        }
        
        guard let amount = aDecoder.decodeObject(forKey: PropertyKey.amount) as? Decimal else {
            fatalError("cannot decode amount")
        }
        
        guard let date = aDecoder.decodeObject(forKey: PropertyKey.date) as? Date else {
            //fatalError("cannot decode date")
            os_log("cannot decode date", log: OSLog.default, type: .error)
            return nil
        }
        
        self.init(category:category, amount:amount, date:date)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(category, forKey: PropertyKey.category)
        aCoder.encode(amount, forKey: PropertyKey.amount)
        aCoder.encode(date, forKey: PropertyKey.date)
    }
    
    
    
    
    
}
