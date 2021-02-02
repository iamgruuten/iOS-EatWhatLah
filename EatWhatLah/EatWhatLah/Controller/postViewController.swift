//
//  postViewController.swift
//  EatWhatLah
//
//  Created by Apple on 1/2/21.
//


import UIKit
import SwiftSpinner

class postViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    
    let firebaseController:FirebaseController = FirebaseController()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var imagePost:UIImage?
    @IBOutlet var postDescription: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupToHideKeyboardOnTapOnView()

        postDescription.becomeFirstResponder()
        
        let bounds = UIScreen.main.bounds

        imagePost = cropToBounds(image: imagePost!, width: Double(bounds.size.width), height: Double(bounds.size.width))
        
        imageView.image = imagePost;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Action methods

    @IBAction func postOnClick(_ sender: Any) {
        SwiftSpinner.show("Uploading Post")
        view.endEditing(true)
        
        let descriptionInput:String = postDescription.text.trimmingCharacters(in: .whitespacesAndNewlines);

        if(descriptionInput != ""){
            firebaseController.addPost(uid: appDelegate.user.uid, image: imagePost!, description: descriptionInput){
                success in
                
                SwiftSpinner.hide()
                
                if(success){
                    self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                    
                }else{
                    let alert = UIAlertController(title: "An error occur", message: "Please check your network", preferredStyle: UIAlertController.Style.alert)
                    
                    // add the actions (buttons)
                    alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertAction.Style.default, handler: { _ in
                        
                    }))
                    
                    // show the alert
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }else{
            
            postDescription.layer.borderColor = UIColor.red.cgColor
            postDescription.layer.borderWidth = 3.0;
        }
    }
    
    // MARK: - Function methods

    //This function is used to crop image
    func cropToBounds(image: UIImage, width: Double, height: Double) -> UIImage {

            let cgimage = image.cgImage!
            let contextImage: UIImage = UIImage(cgImage: cgimage)
            let contextSize: CGSize = contextImage.size
            var posX: CGFloat = 0.0
            var posY: CGFloat = 0.0
            var cgwidth: CGFloat = CGFloat(width)
            var cgheight: CGFloat = CGFloat(height)

            // See what size is longer and create the center off of that
            if contextSize.width > contextSize.height {
                posX = ((contextSize.width - contextSize.height) / 2)
                posY = 0
                cgwidth = contextSize.height
                cgheight = contextSize.height
            } else {
                posX = 0
                posY = ((contextSize.height - contextSize.width) / 2)
                cgwidth = contextSize.width
                cgheight = contextSize.width
            }

            let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)

            // Create bitmap image from context using the rect
            let imageRef: CGImage = cgimage.cropping(to: rect)!

            // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: .right)
        
            return image
        }
    
    // MARK : - Event based
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.layer.borderColor = UIColor.red.cgColor
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        textView.layer.borderColor = UIColor.clear.cgColor
    }
    
}
