//
//  ViewController.swift
//  trashApp
//
//  Created by Labdhi Jain on 1/25/20.
//  Copyright © 2020 Labdhi Jain. All rights reserved.
//

import UIKit
import AVFoundation
import AVFoundation
import CoreML
import Vision
import ImageIO

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var realCamButton: UIButton!
    
    @IBOutlet weak var camButton: UIBarButtonItem!
    
    
    @IBOutlet weak var categoryLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let pulse = Pulse(numberOfPulses: Float.infinity, radius: 75, position: realCamButton.center)
        pulse.animationDuration = 1.0
        pulse.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        self.view.layer.insertSublayer(pulse, below: realCamButton.layer)
        
        // Do any additional setup after loading the view.
        
       
    }
    
    @IBAction func takePicture2(_ sender: Any) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
                   let imagePicker = UIImagePickerController()
                   imagePicker.delegate = self
                   imagePicker.sourceType = UIImagePickerController.SourceType.camera
                   imagePicker.allowsEditing = false
                   self.present(imagePicker, animated: true, completion : nil)
                   
               }
    }
    @IBOutlet weak var imageShow: UIImageView!
    @IBAction func takePhoto(_ sender: Any) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion : nil)
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        imageShow.contentMode = .scaleToFill
        imageShow.image = pickedImage
        
        //pickedImage is the image
        picker.dismiss(animated: true, completion: nil)
        categoryLbl.text = "check"
        
        
    let orientation = CGImagePropertyOrientation(rawValue: UInt32((pickedImage?.imageOrientation)!.rawValue))!
               guard let ciImage = CIImage(image: pickedImage!) else { fatalError("Unable to create \(CIImage.self) from \(pickedImage).") }
              DispatchQueue.global(qos: .userInitiated).async {
                  let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation)
                  do {
                      try handler.perform([self.classificationRequest])
                  } catch {
                      print("Failed to perform classification.\n\(error.localizedDescription)")
                  }
              }
           }
        
           lazy var classificationRequest: VNCoreMLRequest = {//handles accessing and using model
               do {
                   let model = try VNCoreMLModel(for: Recycle().model)//gets our Recycle model
                   
                   let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
                       self?.processClassifications(for: request, error: error)
                   })
                   request.imageCropAndScaleOption = .centerCrop
                   return request
               } catch {
                   fatalError("Failed to load Trash model: \(error)")
               }
           }()
    
    
    func processClassifications(for request: VNRequest, error: Error?){
           DispatchQueue.main.async{//runs at the same time as the main branch
               guard let results = request.results else {
                   self.categoryLbl.text = "Unable to recognize anything"
                  return
               }
               let classifications = results as! [VNClassificationObservation]
               
                   if classifications.isEmpty {
                       self.categoryLbl.text = "Nothing recognized."
                   } else {
                       // Display top classifications ranked by confidence in the UI.
                       let topClassifications = classifications.prefix(2)
                       let descriptions = topClassifications.map { classification in
                           // Formats the classification for display
                          return String(format: "  (%.2f) %@", classification.confidence, classification.identifier)
                       }
                    print(descriptions.joined(separator: "\n"))
                    
                    
                    
                    
                    self.categoryLbl.text = descriptions.joined(separator: "\n")
//                       self.categoryLbl.text = "Classification:\n" + descriptions.joined(separator: "\n")
                   }
           }
       }
       


}

