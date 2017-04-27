//
//  DeviceTableViewController.swift
//  DeviceTracker
//
//  Created by Yogesh Ranjan on 01/04/17.
//  Copyright © 2017 iotguru. All rights reserved.
//

import UIKit
import os.log

class DeviceTableViewController: UITableViewController {
    
    //MARK: Properties
    var devices = [Device]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //add edit bar button on the left of the nvaigation item
        navigationItem.leftBarButtonItem = editButtonItem
        //loadSampleDevices()
        
        if let savedDevices = loadDevices() {
            devices = savedDevices
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Actions
    @IBAction func unwindToDeviceList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? DeviceViewController {
            let device = sourceViewController.device
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                devices[selectedIndexPath.row] = device!
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
                
            } else {
                let newIndexPath = IndexPath(row:devices.count, section:0)
                devices.append(device!)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
        
        saveDevices()
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return devices.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceTableViewCell", for: indexPath) as? DeviceTableViewCell else {
            fatalError("The dequeue cell is not an instance of DeviceTableViewCell")
        }
        
        let device = devices[indexPath.row]
        
        cell.deviceNameLabel.text = device.name
        cell.deviceImageView.image = device.photo
        cell.deviceRatingControl.rating = device.rating
        
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch (segue.identifier ?? "") {
            case "addNewDevice" :
                os_log("adding a new device..", log: .default, type: .debug)
                
            case "showDetail" :
                guard let deviceViewController = segue.destination as? DeviceViewController else {
                    fatalError("unexpected destination view controller - \(segue.destination)")
                }
                guard let selectedDeviceCell = sender as? DeviceTableViewCell else {
                    fatalError("unexpected sender - \(sender)")
                }
                guard let selectedDeviceIndex = tableView.indexPath(for: selectedDeviceCell) else {
                    fatalError("cannot get index for table cell - \(selectedDeviceCell)")
                }
                
                let selectedDevice = devices[selectedDeviceIndex.row]
                deviceViewController.device = selectedDevice
            default:
                fatalError("unexpected segue identifier...")
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            devices.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
        saveDevices()
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    
    //MARK: Private methods
    private func loadSampleDevices() {
        let deviceImage1 = UIImage(named: "device1")
        let deviceImage2 = UIImage(named: "device2")
        let deviceImage3 = UIImage(named: "device3")
        
        guard let device1 = Device(name:"Device 1", photo:deviceImage1, rating:4) else {
            fatalError("unable to create device 1")
        }
        
        guard let device2 = Device(name:"Device 2", photo:deviceImage2, rating:3) else {
            fatalError("unable to create device 2")
        }
        
        guard let device3 = Device(name:"Device 3", photo:deviceImage3, rating:2) else {
            fatalError("unable to create device 3")
        }
        
        devices += [device1, device2, device3]
    }
    
    private func saveDevices() {
        let isSuccessfullSave = NSKeyedArchiver.archiveRootObject(devices, toFile: Device.ArchiveURL.path)
        
        if (isSuccessfullSave) {
            os_log("Devices successfully saved", log: .default, type: .debug)
        } else {
            os_log("Devices failed to save!", log: .default, type: .error)
        }
    }
    
    private func loadDevices() -> [Device]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Device.ArchiveURL.path) as? [Device]
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
