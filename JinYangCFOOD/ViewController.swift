//
//  ViewController.swift
//  JinYangCFOOD
//
//  Created by   Rastogi on 18/12/17.
//  Copyright © 2017 Vinayak Rastogi. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController() //image picker object from the class UIImagePickerController
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // after creating image picker object, set delegate of it as the current class
        imagePicker.delegate = self
        
        //setting other properties
        imagePicker.sourceType = .camera  //brings up a UIImagePicker that contains the camera module to allow the user to take an image using the front or rear camera
        imagePicker.allowsEditing = false   //boolean val. whether the user is allowed to edit a selected image or movie.

        
    
    }
    
    // delegate method for the timepoint when the user has picked the image
    // this method comes from UIImagePickerControllerDelegate class that tells the class that the user has picked the image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        //the "picker" is the UIImagePickerController that was used to pick the image, ie the imagePicker object
        // next, the didFinish... info is a dictionary, inside which is the image that the user picked.
        
        //specifying the original uncropped image selected by the user
        //an optional binding
        if let userPickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage //downcasting to image datatype
        {
            imageView.image = userPickedImage
        }
        
        //finally we're gonna dismiss that imagepicker and go back to our viewcontroller
        imagePicker.dismiss(animated: true, completion: nil)
    }

    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        //when the camera button is tapped, we're asking it to present this imagePicker to the user
        present(imagePicker, animated: true, completion: nil)
        
    }
}

