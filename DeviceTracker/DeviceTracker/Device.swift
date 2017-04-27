//
//  Device.swift
//  DeviceTracker
//
//  Created by Yogesh Ranjan on 31/03/17.
//  Copyright © 2017 iotguru. All rights reserved.
//

import UIKit
import os.log

class Device : NSObject, NSCoding {
    
    //MARK:Properties
    
    var name:String
    var photo:UIImage?
    var rating:Int
    
    //MARK: Types
    
    struct PropertyKey {
        static let name = "name"
        static let photo = "photo"
        static let rating = "rating"
    }
    
    //MARK: Archiving file paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("devices")
    
    //MARK:Initialization
    
    init?(name:String, photo:UIImage?, rating:Int) {
        
        //init should fail if incorrect values are passed
        if (name.isEmpty || rating < 0) {
            return nil
        }
        
        self.name = name
        self.photo = photo
        self.rating = rating
    }
    
    required convenience init? (coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        
        let rating = aDecoder.decodeInteger(forKey: PropertyKey.rating)
        
        self.init(name: name, photo:photo, rating:rating)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(rating, forKey: PropertyKey.rating)
    }
}
