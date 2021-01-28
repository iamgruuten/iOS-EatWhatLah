//
//  LoginViewController.swift
//  EatWhatLah
//
//  Created by Apple on 23/1/21.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseStorage
import SwiftSpinner
import CoreLocation

class LoginViewController:UIViewController{
    
    
    
    @IBOutlet weak var userPasswordField: UITextField!
    @IBOutlet weak var userTextView: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let userController:UserController = UserController();
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Since multiple view controller are connected to the controller
        //There will be a need to check the id for each load
        
        if(self.restorationIdentifier == "welcomeSB"){
            
            self.userTextView.text = "Welcome Back, " + self.appDelegate.user.name;
        }
        
    }
    
    @IBAction func loginBtnOnClick(_ sender: Any) {
        self.view.endEditing(true)

        SwiftSpinner.show("We are logging you in...")

        SwiftSpinner.show(delay: 2.0, title: "It's taking longer than expected")

        let password = userPasswordField.text;
        let email = appDelegate.user.email;
        
        Auth.auth().signIn(withEmail: email, password: password!) { (authResult, error) in
            if let error = error as NSError? {
                SwiftSpinner.hide();
                var errorMessage:String = "Unknown error has occured";
                
                switch AuthErrorCode(rawValue: error.code) {
                    case .operationNotAllowed:
                        errorMessage = "Operation not allowed";
                    case .userDisabled:
                        errorMessage = "Your account has been disabled"
                    case .wrongPassword:
                        errorMessage = "Wrong Password"
                    default:
                        print("Error: \(error.localizedDescription)")
                }
                let alert = UIAlertController(title: "Oh no! An error has occured", message: errorMessage, preferredStyle: UIAlertController.Style.alert)
            
            // add the actions (buttons)
            alert.addAction(UIAlertAction(title: "Try again", style: UIAlertAction.Style.default))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
          } else {
            print("User signs in successfully")
            let userInfo = Auth.auth().currentUser
            
            //Retrieve user data
            let ref = Database.database().reference().child("users").child(userInfo!.uid)

            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                    let userDetails = snapshot.value as? NSDictionary
                    
                    //Storing users data in appDelegate
                    self.appDelegate.user.email = userDetails?["Email"] as! String
                    self.appDelegate.user.uid = userInfo!.uid
                    self.appDelegate.user.bio = userDetails?["Bio"] as! String
                    self.appDelegate.user.name = userDetails?["Name"] as! String
                
                    let storage = Storage.storage()

                    let gsReference = storage.reference(forURL:userDetails?["profileURL"] as! String)
                                            
                    gsReference.getData(maxSize: 10 * 1024 * 1024) { data, error in
                        if let error = error {
                          // Uh-oh, an error occurred!
                            print(error)
                        } else {
                            self.appDelegate.user.profilePicture = UIImage(data: data!)!
                            
                          //Complete login

                          SwiftSpinner.hide();
                          
                          self.userController.AddUser(user: self.appDelegate.user)
                          
                          let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                          
                          let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MainSB")
                          
                          nextViewController.modalPresentationStyle = .fullScreen
                          
                          self.present(nextViewController, animated:false, completion:nil)
                        }
                      }
          })
        }
    }
    }
    

    //Back Button On Click
    @IBAction func backBtnOnClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //Get email user input
    @IBAction func nextOnClick(_ sender: Any) {
        self.view.endEditing(true)

        SwiftSpinner.show("Retrieving Details...")
        let email:String = emailField.text!;
        
        if(email == ""){
            //Do error
            emailField.layer.borderColor = UIColor.red.cgColor
            emailField.layer.borderWidth = 1.0
            
        }else{
            //Look for email exist
            let ref = Database.database().reference().child("users")

            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                 if let userDict = snapshot.value as? [String:Any] {
                    for user in userDict {
                        let userDetails = user.value as? NSDictionary
                        let emaildata = userDetails?["Email"] as? String ?? ""
                        
                        
                        if(emaildata == email){
                            //Found email
                            self.appDelegate.user.name = userDetails?["Name"] as? String ?? ""
                            self.appDelegate.user.email = email;
                            
                            
                            let storyBoard : UIStoryboard = UIStoryboard(name: "onboard", bundle:nil)
                            
                            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "welcomeSB")
                            
                            nextViewController.modalPresentationStyle = .fullScreen
                            
                            self.present(nextViewController, animated:false, completion:nil)
                            
                            
                            break;
                            
                            
                            
                        }
                    }
                    
                    SwiftSpinner.hide();
                    
                    let alert = UIAlertController(title: "Oh no! An error has occured", message: "Email is not registered yet", preferredStyle: UIAlertController.Style.alert)
                    
                    // add the actions (buttons)
                    alert.addAction(UIAlertAction(title: "Noted", style: UIAlertAction.Style.default))
                    
                    // show the alert
                    self.present(alert, animated: true, completion: nil)
                    
                 }
            })
            
        }
    }
    
    //Load image from directory
    
    func loadImage(at path: String) -> UIImage? {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentPath = paths[0]
        let imagePath = documentPath.appending(path)
        guard fileExists(at: imagePath) else {
            return nil
        }
        guard let image = UIImage(contentsOfFile: imagePath) else {
            return nil
        }
        return image
    }

    func fileExists(at path: String) -> Bool {
        return FileManager.default.fileExists(atPath: path)
    }
}
