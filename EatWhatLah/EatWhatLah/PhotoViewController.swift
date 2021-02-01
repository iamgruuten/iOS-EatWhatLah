//
//  PhotoViewController.swift
//  EatWhatLah
//
//  Created by Apple on 1/2/21.
//

import UIKit

class PhotoViewController: UIViewController {
     @IBOutlet var imageView: UIImageView!
       
       var image:UIImage?
    @IBOutlet var postDescription: UITextField!
    
       override func viewDidLoad() {
           super.viewDidLoad()

           imageView.image = image
       }

       override func didReceiveMemoryWarning() {
           super.didReceiveMemoryWarning()
           // Dispose of any resources that can be recreated.
       }
       

    @IBAction func confirmOnClick(_ sender: Any) {
    }
    
    // MARK: - Action methods
       
       @IBAction func save(sender: UIButton) {
       }
}
