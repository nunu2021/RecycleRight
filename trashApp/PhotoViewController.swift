//
//  PhotoViewController.swift
//  trashApp
//
//  Created by Labdhi Jain on 1/25/20.
//  Copyright © 2020 Labdhi Jain. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {
    
    var takenPhoto:UIImage?

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let availableImage = takenPhoto{
            imageView.image=availableImage
        }

        // Do any additional setup after loading the view.
    }
    

    @IBAction func goBack(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
