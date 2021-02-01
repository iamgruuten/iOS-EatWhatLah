//
//  PhotoViewController.swift
//  EatWhatLah
//
//  Created by Apple on 1/2/21.
//

import UIKit
import SwiftSpinner

class PhotoViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    
    let firebaseController:FirebaseController = FirebaseController()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var image:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = image
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
    // MARK: - Action methods

    @IBAction func confirmOnClick(_ sender: Any) {
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let postViewController = mainStoryboard.instantiateViewController(withIdentifier: "PostViewController") as! postViewController
        postViewController.modalPresentationStyle = .fullScreen

        postViewController.imagePost = image;
        self.present(postViewController, animated: true)
    }
    
    
}
