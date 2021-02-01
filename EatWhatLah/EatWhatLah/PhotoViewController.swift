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
    @IBOutlet var postDescription: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = image
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func postOnClick(_ sender: Any) {
        var description = postDescription.text.trimmingCharacters(in: .whitespacesAndNewlines);

        if(description != ""){
            
            
        }else{
            
            postDescription.layer.borderColor = UIColor.red.cgColor
            postDescription.layer.borderWidth = 3.0;
        }
    }
    
    @IBAction func confirmOnClick(_ sender: Any) {
    }
    
    // MARK: - Action methods
    
    @IBAction func save(sender: UIButton) {
    }
}
