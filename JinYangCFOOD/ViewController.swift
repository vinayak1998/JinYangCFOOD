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
            
            //now to convert ui image to ci(core image) image, allows us to use the vision framework on the image
            //extra security feature to make the code safer

            guard let ciimage = CIImage(image: userPickedImage) else {
                fatalError("Could not convert UIImage into CIImage")
            }
            
            detect(image: ciimage) // calling the most exquisite method in the code
        }
        
        //finally we're gonna dismiss that imagepicker and go back to our viewcontroller
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    //after conversion of ciimage to uiimage, we need a method to process the ciimage and get a classification out of it
    func detect(image: CIImage){
        
        //using the inception v3 model now,
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model)  //a container for a coreML model used for vision requests
            else{
                fatalError("Loading CoreML Model Failed")
        }
        
        //now we're going to access this model object that we created and create a viosion coreML request
        let request = VNCoreMLRequest(model: model) { (request, error) in
            
            //code completion request that is when that request is completed, to process the results of that request
            // create object results to do the above
            guard let results = request.results as? [VNClassificationObservation] else{
                fatalError("model failed to process image")
            }
            
            //print(results) //results that we get after classification
            
            // the first result has the most confidence
            // CHANGE THE ARGUMENT PASSED TO THE CONTAINS METHOD AS DESIRED
            /*if let firstResult = results.first{
                if firstResult.identifier.contains("hotdog"){
                    self.navigationItem.title = "HotDog! :D"
                }else{
                    self.navigationItem.title = "NOT HotDog! D:"
                }
            }*/
            let firstResult = results.first
            self.navigationItem.title = firstResult?.identifier
        }
        
        // creating a handlrer that specifies the image to be calssified
        let handler = VNImageRequestHandler(ciImage: image) //image is the parameter name of the detect func
        
        do{
            try handler.perform([request])
        }
        catch{
            print(error)
        }
    
    }

    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        //when the camera button is tapped, we're asking it to present this imagePicker to the user
        present(imagePicker, animated: true, completion: nil)
        
    }
}

