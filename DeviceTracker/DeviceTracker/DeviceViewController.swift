//
//  ViewController.swift
//  DeviceTracker
//
//  Created by Yogesh Ranjan on 11/02/17.
//  Copyright © 2017 iotguru. All rights reserved.
//

import UIKit
import os.log

class DeviceViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: Properties
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var deviceNameText: UITextField?
    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet weak var saveDeviceButton: UIBarButtonItem!
    
    var device:Device?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //when editing an existing device detail, we will have a the device object populated
        if let device = device {
            navigationItem.title = device.name
            deviceNameText?.text = device.name
            imageView?.image = device.photo
            ratingControl.rating = device.rating
        }
        updateSaveDeviceButtonState()
        deviceNameText?.delegate = self
    }
    
    //MARK:Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIBarButtonItem, button === saveDeviceButton else {
            os_log("save button was not pressed, exiting..", log: OSLog.default, type: .debug)
            return
        }
        device = Device(name: deviceNameText?.text ?? "", photo: imageView?.image, rating: ratingControl.rating)
        
        //unwind to previous view controller
    }
    
    //MARK: Actions
    
    @IBAction func addNewDevice(_ sender: UIButton) {
        let msg:String = "Device \(deviceNameText!.text!) added";
        self.present(getErrorAlertController(message: msg), animated:true, completion: nil)

    }
    
    @IBAction func selectImageFromGallery(_ sender: UITapGestureRecognizer) {
        deviceNameText?.resignFirstResponder()
        let imagePickupController = UIImagePickerController()
        imagePickupController.sourceType = .photoLibrary
        imagePickupController.delegate = self
        present(imagePickupController, animated:true, completion: nil)
        
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        let isPresentingVCInAddMode = presentingViewController is UITabBarController
        if (isPresentingVCInAddMode) {
            dismiss(animated: true, completion: nil)
        } else if let owningNavigationVC = navigationController {
            owningNavigationVC.popViewController(animated: true)
        } else {
            fatalError("The MealViewController is not inside a navigation controller.")
        }
    }
    
    //MARK:TextFieldDelegate 
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //let msg:String = "Device \(deviceNameText!.text!) added";
        //self.present(getErrorAlertController(message: msg), animated:true, completion: nil)
        updateSaveDeviceButtonState()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveDeviceButton.isEnabled = false
    }
    
    //MARK: UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion:nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        imageView?.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK:Helper methods
    
    func getErrorAlertController(message: String) -> UIAlertController {
        let alertController = UIAlertController(title: "Done", message: "\(message)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (alert: UIAlertAction) -> Void in }
        alertController.addAction(okAction)
        return alertController
    }
    
    private func updateSaveDeviceButtonState() {
        saveDeviceButton.isEnabled = !deviceNameText!.text!.isEmpty
    }
    

}

